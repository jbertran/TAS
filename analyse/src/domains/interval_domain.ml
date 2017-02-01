open Abstract_syntax_tree
open Value_domain
open Domain


module Interval =
  (struct

    type bound =
      | B of Z.t
      | INF
      | FNI

    type t =
      | Elem of bound * bound
      | BOT
      | TOP

    let top: t = TOP

    let bottom: t = BOT

    let min_bounds (a: bound) (b: bound): bound =
      match a, b with
      | FNI, _ | _, FNI -> FNI
      | INF, B a | B a, INF -> B a
      | B a, B b -> B (Z.min a b)

    let lift1 f x =
      match x with
      | BOT -> BOT
      | TOP -> TOP
      | Elem _ as e -> f e

    let lift2 (f: t -> t -> t) (x: t) (y: t): t =
      match x, y with
      | BOT, _ | _, BOT -> BOT
      | TOP, _ | _, TOP -> TOP
      | Elem _ , Elem _ -> f x y

    let get_char (a: bound): string =
      match a with
      | INF -> "INF"
      | FNI -> "FNI"
      | B x -> Z.to_string x

    let lo_b (a_min: bound) (b_min: bound): bound =
      match a_min, b_min with
      | FNI, _ | _, FNI -> FNI
      | B x, B y -> if x > y then B y else B x
      | INF, B y -> B y
      | B x, INF -> B x
      | INF, INF -> INF

    let hi_b (a_max: bound) (b_max: bound): bound =
      match a_max, b_max with
      | INF, _ | _, INF -> INF
      | B x, B y -> if x > y then B x else B y
      | FNI, B y -> B y
      | B x, FNI -> B x
      | FNI, FNI -> FNI

    let make_elem (a: bound) (b: bound): t =
      match a, b with
      | B av, B bv -> if av < bv then Elem (B av, B bv) else Elem (B bv, B av)
      | FNI, B a | B a, FNI -> Elem (FNI, B a)
      | INF, B a | B a, INF -> Elem (B a, INF)
      | INF, FNI | FNI, INF -> Elem (FNI, INF)
      | _ -> BOT

    let const (c: Z.t): t =
      make_elem (B c) (B c)

    let rand (a: Z.t) (b: Z.t): t =
      make_elem (B a) (B b)

    let rand_itvl (a: t) (b: t): t =
      match a, b with
      | BOT, _ | _, BOT -> BOT
      | TOP, TOP -> TOP
      | TOP, Elem (B a, B b) -> make_elem FNI (B b)
      | Elem (B a, B b), TOP -> make_elem (B a) INF
      | Elem (B a, B b), Elem (B c, B d) -> make_elem (B a) (B d)

    let neg =
      let ens_neg = function
        | Elem (B a, B b) -> make_elem (B (Z.neg b)) (B (Z.neg a))
        | Elem (FNI, B a) -> make_elem (B (Z.neg a)) INF
        | Elem (B a, INF) -> make_elem FNI (B (Z.neg a))
        | Elem (FNI, INF) -> TOP
        | _ -> BOT
      in lift1 ens_neg

    let apply_same (f: Z.t -> Z.t -> Z.t) (a: t) (b: t): t =
      match a, b with
      | Elem (B a, INF), Elem (B b, _) | Elem (B b, _), Elem (B a, INF) -> make_elem (B (f a b)) INF
      | Elem (FNI, B a), Elem (_, B b) | Elem (_, B b), Elem (FNI, B a) -> make_elem FNI (B (f a b))
      | Elem (B a, B b), Elem (B c, B d) -> make_elem (B (f a c)) (B (f b d))
      | _ -> BOT

    let apply_opposite (f: Z.t -> Z.t -> Z.t) (a: t) (b: t): t =
      match a, b with
      | Elem (B a, INF), Elem (B b, _) | Elem (B b, _), Elem (B a, INF) -> make_elem (B (f a b)) INF
      | Elem (FNI, B a), Elem (_, B b) | Elem (_, B b), Elem (FNI, B a) -> make_elem FNI (B (f a b))
      | Elem (B a, B b), Elem (B c, B d) -> make_elem (B (f a d)) (B (f b c))
      | _ -> BOT

    let add = lift2 (apply_same Z.add)

    let mul = lift2 (apply_same Z.mul)

    let sub = lift2 (apply_opposite Z.sub)

    let div = lift2 (apply_opposite Z.div)

    let modu (x: t) (y: t) =
      let ens_mod x y=
        match x, y with
        | Elem _, Elem (_, B d) -> make_elem (B Z.zero) (B d)
        | Elem (_, B b), Elem (_, INF) -> make_elem (B Z.zero) (B b)
        | Elem (_, INF), Elem (_, INF) -> make_elem (B Z.zero) INF
        | _ -> TOP
      in lift2 ens_mod x y

    let join (a :t) (b :t) =
      match a, b with
      | BOT, _ -> b
      | _, BOT -> a
      | Elem (min_a, max_a), Elem (min_b, max_b) ->
        Elem (lo_b min_a min_b, hi_b max_a max_b)
      | TOP, _ | _, TOP -> TOP

    let meet (a :t) (b :t) : t =
      match a, b with
      | BOT, _ | _, BOT -> BOT
      | Elem (min_a, max_a), Elem (min_b, max_b) ->
         let (up, lo) = (hi_b min_a min_b, lo_b max_a max_b) in
         Elem (lo_b up lo, hi_b up lo)

    let eq (a: t) (b: t) = let res = meet a b in res, res

    let neq (a: t) (b: t) =
      match a, b with
      | BOT, _ | _, BOT -> BOT, BOT
      | TOP, a -> TOP, a
      | a, TOP -> a, TOP
      | Elem (B w, B x), Elem (B y, B z) when (w = x && x = y && y = z) -> BOT, BOT
      | a, b -> a, b
      | _ -> BOT, BOT

      let print (fmt: Format.formatter) (a: t): unit =
      match a with
      | BOT -> Format.fprintf fmt "bottom"
      | Elem (min_a, max_a) -> Format.fprintf fmt "[%s, %s]"
      (get_char min_a) (get_char max_a)

    let geq (a: t) (b: t) =
      match a, b with
      | TOP, _ -> a, b
      | Elem (B c, B d), TOP -> make_elem FNI (B c), TOP
      | BOT, _ | _, BOT -> a, b
      | Elem (a, b), Elem (c, d) -> make_elem (min_bounds a c) b, make_elem c (min_bounds b d)

    let gt (a: t) (b: t) =
      let geqa, geqb = geq a b in
      let Elem (B a_lo, B a_hi), Elem (B b_lo, B b_hi) = geqa, geqb in
      if b_hi = a_lo then
        Elem (B (Z.add a_lo Z.one), B a_hi), geqb
      else geqa, geqb

    let subset (a: t) (b :t): bool =
      match a, b with
      | BOT, _ -> true
      | _, BOT -> false
      | Elem (min_a, max_a), Elem (min_b, max_b) ->
         let (up, lo) = (hi_b min_a min_b, lo_b max_a max_b) in
         ((up = max_b) && (lo = min_b))

    let is_bottom (a: t): bool =
      a = BOT

    let unary (x: t) (op: int_unary_op): t = match op with
      | AST_UNARY_PLUS  -> x
      | AST_UNARY_MINUS -> neg x

    let binary (x: t) (y: t) (op: int_binary_op): t =
      match op with
      | AST_PLUS     -> add x y
      | AST_MINUS    -> sub x y
      | AST_MULTIPLY -> mul x y
      | AST_DIVIDE   -> div x y
      | AST_MODULO   -> modu x y


    let widen (x: t) (y: t) =
      match x, y with
      | BOT, _ | _, BOT -> BOT
      | TOP, _ | _, TOP -> TOP
      | Elem (B a, B b), Elem (B c, B d) ->
        make_elem (if a <= c then (B a) else FNI)
                  (if b >= d then (B b) else INF)

    let compare (x: t) (y: t) (op: compare_op): (t * t) = match op with
      | AST_EQUAL         -> eq  x y
      | AST_NOT_EQUAL     -> neq x y
      | AST_GREATER_EQUAL -> geq x y
      | AST_GREATER       -> gt  x y
      | AST_LESS_EQUAL    -> let y', x' = geq y x in x', y'
      | AST_LESS          -> let y', x' = gt y x in x', y'

    let bwd_unary (x: t) (op: int_unary_op) (r: t): t = match op with
      | AST_UNARY_PLUS  -> meet x r
      | AST_UNARY_MINUS -> meet x (neg r)


    let bwd_binary (x: t) (y: t) (op: int_binary_op)  (r: t): (t * t) =
      match op with
      | AST_PLUS -> meet x (sub r y), meet y (sub r x)
      | AST_MINUS -> meet x (add y r), meet y (sub y r)
      | AST_MULTIPLY -> meet x (div r y), meet y (div r x)
      | AST_MODULO -> x, y
      | AST_DIVIDE -> meet x (mul r y), meet y (mul r x)

  end : VALUE_DOMAIN)
