# printf() implementée en ASM x64

## Auteur : Sergiu Iacob

---

## Fonctionnalités existantes :
La fonction `printf` a été implementée comme `myprintf`. J'ai également implementée `fprintf` comme `fmyprintf`. Ils peuvent être utilisés avec :
1. caractères simples
2. des "strings" simples
3. paramètres des caractères
4. paramètres des strings
5. paramètres des entiers
6. paramètres de hex
7. paramètres des tableaux (entiers)
8. paramètres des tableaux (hex)
9. de multiples paramètres (n'importe quel nombre) qui peuvent être combinés : caractères, entiers, tableaux etc.

Tous ces éléments sont présentés dans le fichier [main.c](./main.c).

`myprintf` montre les résultats à l'écran, et `fmyprintf` montre le résultat dans un fichier `test.out`.

---

## Functionalities not implemented:
1. floats

---

## Problèmes
Toutes les fonctionnalités implementées fonctionnent comme prévu, il n'y a pas de problèmes. Elles ont été testées sur les ordinateurs universitaires de M5, Université de Lille.