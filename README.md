# flex-bison

Simple programming language written with Flex, Bison and C++.

## Syntax

### Instructions

- Assignment - `variable_name = EQUATION ;`
- Print expression 
  - `PRINT EQUATION ;`
  - `PRINT VARIABLE ;`
- Condition statement - `IF CONDITION INSTRUCTION ;`
- While loop - `WHIE VARIABLE ASSIGNMENT INSTRUCTION ;`

### Symbols Explanation

- EQUATION
  - number
  - variable
  - additon - `EQUATION + EQUATION`
  - subtraction - `EQUATION - EQUATION`
  - division - `EQUATION / EQUATION`
  - multiplication - `EQUATION * EQUATION`
- CONDITION - `EQUATION SIGN EQUATION` where `SIGN` is one of `<`, `>`, `<=`, `>=`, `!=`, `==`
- INSTRUCTION - single instriction

## Built With

* MinGW
* Bison
* Flex

### Build Commands
* flex skaner.l
* bison -dy parser.y
* g++ lex.yy.c y.tab.c -o `filename.exe`
