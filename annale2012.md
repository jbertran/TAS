# Ex4. Surcharge et liaison tardive

```java
class A {
    int a;
    A (int a) {this.a = a}
    public String toString() {
        return '[' + this.a + ']';
    }
    A max(A x) {
        if (this.compareTo(x) <= 0) return x;
        else return x;
    }
    int getA() {return a;}
    int compareTo(A x){
        return a.compareTo(x.getA());
    }
}

class B {
    B (int b) {super(b/2); this.b=b;}
    public String toString() { return " ( "+b+" ,"+super.toString()+" ) " ; }
    A max ( A y ) { i f ( this.compareTo ( y ) <= 0 ) return y ; else return this ; }
    B max ( B y ) { i f ( this.compareTo ( y ) <= 0 ) return y ; else return this ; }
    int getB () { return b ; }
    int compareTo ( B y ) {
    int b2 = y.getB () ;
    int r = super.compareTo ( y ) ;
    if ( r == 0 )
    if ( b < b2 ) return −1; 
    elseif ( b > b2 ) return 1 ; else return 0 ;
    else return r ;
    }
}
```

## Q1

```java
A a1 = new A(400);
B b1 = new B(100);
B b2 = new B(200);
A a2 = b2 ;
System.out.println(a1);
System.out.println(b1);
System.out.println(b2);
System.out.println(a2);
```

* a1 = [400]
* b1 = [100;[50]]
* b2 = [200;[100]]
* a2 = [200;[100]]

```java
A a3 = a1.max(a2);
A a4 = a2.max(a1);
B b3 = b1.max(b2);
B b4 = b2.max(b1);
System.out.println(a3);
System.out.println(a4);
System.out.println(b3);
System.out.println(b4);
```

* a3 = [400]
* a4 = [400]
* b3 = [200, (100)]
* b4 = 

```java
A a5 = b2.max ( b1 ) ;
A a6 = b2.max ( a1 ) ;
A a7 = b2.max ( a2 ) ;
A a8 = a2.max ( b2 ) ;
System.out.println ( a5 ) ;
System.out.println ( a6 ) ;
System.out.println ( a7 ) ;
System.out.println ( a8 ) ;
```

* a5 = (200, [100])
* a6 = [400]
* a7 = (200, [100])
* a8 = (200, [100])
