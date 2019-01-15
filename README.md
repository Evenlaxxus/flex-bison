# flex-bison

Prosty język programowania stworzony za pomocą Flex, Bison and C++.

## Składnia

### Instrukcje

- Przypisanie wartości do zmiennej - `variable_name = EQUATION ;`
- Wypisanie działania lub zmiennej 
  - `PRINT EQUATION ;`
  - `PRINT VARIABLE ;`
- Instrukcja warunkowa - `IF CONDITION INSTRUCTION ;`
- Pętla while - `WHIE VARIABLE ASSIGNMENT INSTRUCTION ;`

### Wyjaśnienie Symboli

- EQUATION
  - liczba
  - zmienna
  - dodawanie - `EQUATION + EQUATION`
  - odejmowanie - `EQUATION - EQUATION`
  - dzielenie - `EQUATION / EQUATION`
  - mnożenie - `EQUATION * EQUATION`
- CONDITION - `EQUATION SIGN EQUATION` gdzie `SIGN` należy do {`<`, `>`, `<=`, `>=`, `!=`, `==`}
- INSTRUCTION - pojedyncza instrukcja

## Kolejność wykonywania działań

Kolejność wykonywania działań jest zaimplementowana przy użyciu odwrotnej notacji polskiej.

Ustalenie wagi znaków operacji:
```c++
    if(ch == "/" || ch == "*") return 2;
    else if(ch == "-" || ch == "+") return 1;
```
Funkcja zwracająca stos znaków:
```c++
std::stack<std::string> infix2postfix(std::string infix);
```
Przykładowy stos:
 - Rówanie wejściowe: 3+4+5/2*(2-4)
 - Odwrotna notacja polska: 3 4 + 5 2 / 2 4 - * +
 - Stos: 3 -> 4 -> + -> 5 -> 2 -> / -> 2 -> 4 -> - -> * -> +

## Funkcjonalność
 
 - Rozwiązywanie prostych operacji matematycznych z poprawną kolejnością wykonywania działań
 - Wypisywanie wyników działań
 - Wykonywanie instrukcji na podstawie instrukcji warunkowej
 - Wykonywanie instrukcji w pętli while
 
## Kompilacja

### Skompilowano za pomocą
* MinGW
* Bison
* Flex

### Użyte komendy konsolowe
* flex skaner.l
* bison -dy parser.y
* g++ lex.yy.c y.tab.c -o `filename.exe`
