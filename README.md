# flex-bison

Simple programming language written with Flex, Bison and C++.

## Syntax

### Instructions

- Assignment - `variable_name = EQUATION ;`
- Print expression 
  - `PRINT EQUATION ;`
  - `PRINT VARIABLE ;`
- Condition statement - `IF CONDITION EXPRESSION ;`
- While loop - `WHIE VARIABLE ASSIGNMENT EXPRESSION ;`

### Symbols Explanation

- EQUATION
  - number
  - variable
  - additon
  - subtraction
  - division
  - multiplication
- EXPRESSION
  - assignment
  - print statement
  - condition statement
- CONDITION - `EQUATION SIGN EQUATION` where `SIGN` is one of `<`, `>`, `<=`, `>=`, `!=`, `==`

## Built With

* MinGW
* Bison
* Flex
