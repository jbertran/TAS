# Rapport TAS - Fiche de lecture

Article: _Compact Bit Encoding Schemes for Simply-Typed Lambda-Terms_, Kotaro Takeda, Naoki Kobayashi, Kazuya Yaguchi, Ayumi Shinohara, _ICFP 2016_

## Résumé

L'article présente deux approches de codage de lambda-termes en chaînes binaires pour obtenir une représentation compacte d'un programme fonctionnel.

## Contexte

Travaux de Kobayashi sur l'encodage de structures arborescentes en un programme fonctionnel (i.e. traduisible en lambda-termes) produisant la structure
en sortie. L'article présente des méthodes examinées pour compresser cette représentation intermédiaire efficacement.

Avantages de la compression d'ordre supérieur:

* En théorie, le ratio de compression peut être _très elevé_.
* Les données compressées peuvent être manipulées _sans décompression_.
* On peut émuler facilement d'autres schémas de compression.

Pour exploiter la puissance de compression de ces idées, il est nécessaire de savoir encoder de manière compacte des lambda-termes.

## Points principaux

### Encodage de De Bruijn

### Première approche: codage sans étiquette de lambda-termes basé sur les types

### Deuxième approche: codage basé sur des grammaires

### Travaux liés

## Discussion
