%{
	#include <iostream>
	#include <stdio.h>
	#include <string>
	#include <cstring>
	#include <map>
	#include <stdlib.h>
	#include <stack>
	#include <vector>
	#include <cstdlib>
	#include <cmath>

	void yyerror(std::string msg);
	int yylex();

	std::map<std::string, double> zmienne;

    enum OPERATIONS{WYPISZ, JEZELI, PETLA_WHILE, PRZYPISZ};

	struct Instruction{
		int name;    		
		std::string variable="";
		std::string equation="";
        int condition;
        

        Instruction(int name, std::string equation) : name(name), equation(equation){};

        Instruction(int name, int condition) : name(name), condition(condition){};

        Instruction(int name, std::string variable, std::string equation) : name(name), variable(variable), equation(equation){};
	};


    double square_root(double P, double eps);    

    double square(double x, int n);

    double factorial(double n);

	int getWeight(std::string ch);

	std::stack<std::string> infix2postfix(std::string infix);

	double calculatePostfix(std::stack<std::string> postfix);

	void executeInstruction(std::vector<Instruction> &instr, int &i);

    int checkCondition(std::string num1, std::string sign, std::string num2);
	

%}

%union {
    double iValue;
	std::string* vName;
    std::vector<Instruction>* instruction_vector;
}

%start PROG

//tokeny z typem danych
%token <vName> EQUATION 
%token <vName> SIGN 
%token <vName> VAR

// typy
%type <instruction_vector> INST
%type <vName> EXP 
%type <iValue> COND


// tokeny bez typu danych
%token UNK PRINT WHILE IF


%%

PROG: PROG INST ';' {
        for(int i=0; i<(*$2).size();i++){
            executeInstruction(*$2, i);
        }
    }
    | /*nic*/
    ;

INST: PRINT EXP {
        $$ = new std::vector<Instruction>{Instruction(WYPISZ, *$2)};
    }
    | VAR '=' EXP {
        $$ = new std::vector<Instruction>{Instruction(PRZYPISZ, *$1, *$3)};
    }
    | IF COND INST {
        $$ = new std::vector<Instruction>{Instruction(JEZELI, $2)};
        $$->push_back((*$3)[0]);
    }
    | WHILE VAR VAR '=' EQUATION INST {
        $$ = new std::vector<Instruction>{Instruction(PETLA_WHILE, *$2, *$5)};
        Instruction instr = Instruction(PRZYPISZ,*$3, *$5);
        $$->push_back(instr);
        $$->push_back((*$6)[0]);
    }
    ;

EXP: VAR {
        $$ = &(*$1);
    }
    | EQUATION {
        $$ = &(*$1);
    }
    ;

COND: EXP SIGN EXP{
        $$ = checkCondition(*$1, *$2, *$3);
    }
    ;
%%

int main()
{
	yyparse();
}
void yyerror(char* str)
{
	printf("%s",str);
}
int yywrap()
{
	return 0;
}



double square(double x, int n){
    if(n==0){
        return 1;
    }
    if(n%2!=0){
        return x*square(x,n-1);
    }else{
        double a = square(x, n/2);
        return a*a;
    }
}

double square_root(double P){
    double a = 1.0, b = P;
    const double eps = 0.000001;

    while(fabs(a-b)>=eps){
        a = (a+b)/2.;   
        b = P/a;
    }
    return a; 
}

double factorial(double n){
    if(n<2){
        return 1;
    }
    return n*factorial(n-1);
}

int checkCondition(std::string num1, std::string sign, std::string num2){
    int v1 = calculatePostfix(infix2postfix(num1));
    int v2 = calculatePostfix(infix2postfix(num2));
   if(sign == ">"){
        if(v1 > v2){
            return 1;
        }else{
            return 0;
        }
    }else if(sign == "<"){
        if(v1 < v2){
            return 1;
        }else{
            return 0;
        }
    }else if(sign == ">="){
        if(v1 >= v2){
            return 1;
        }else{
            return 0;
        }
    }else if(sign == "<="){
        if(v1 <= v2){
            return 1;
        }else{
            return 0;
        }
    }else if(sign == "=="){
        if(v1 == v2){
            return 1;
        }else{
            return 0;
        }
    }else if(sign == "!="){
        if(v1 != v2){
            return 1;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

int getWeight(std::string ch) {
    if(ch == "^" || ch == "#" || ch == "!" || ch == "%") return 3;
    else if(ch == "/" || ch == "*") return 2;
    else if(ch == "-" || ch == "+") return 1;
    else return 0;
}


std::stack<std::string> infix2postfix(std::string infix) {
    std::vector<std::string> postfix;
    std::stack<std::string> s;
    int weight;
    int i = 0;
    while (i < infix.size()) {
        if (infix[i] == '(') {
            s.push("(");
            i++;
            continue;
        }
        if (infix[i] == ')') {
            while (!s.empty() && s.top() != "(") {
                postfix.push_back(s.top());
                s.pop();
            }
            if (!s.empty()) {
                s.pop();
            }
            i++;
            continue;
        }
        weight = getWeight(infix.substr(i,1));
        if (weight == 0) {
            int k=i;
            std::string tmp;
            while(infix[k] != '+' && infix[k] != '-' && infix[k] != '*' && infix[k] != '/' && infix[k] != '^' && infix[k] != '#' && infix[k] != '!' && infix[k] != '%' && infix[k] != ')' && k < infix.size()){
                tmp += infix.substr(k,1);
                k++;
            }
            i=k-1;
            postfix.push_back(tmp);
        }else if (s.empty()) {
            s.push(infix.substr(i,1));
        } else {
            while (!s.empty() && s.top() != "(" && weight <= getWeight(s.top())) {
                postfix.push_back(s.top());
                s.pop();
            }
                s.push(infix.substr(i,1));
        }
        i++;
    }
    while (!s.empty()) {
        postfix.push_back(s.top());
        s.pop();
    }

    for(int j=postfix.size()-1;j>=0;j--){
        s.push(postfix[j]);
        // std::cout<<s.top()<<" ";
    }
       // std::cout<<"\n";
    return s;
}

double calculatePostfix(std::stack<std::string> postfix){
    std::vector<double> result;
    double val1;
    double val2;
    while (!postfix.empty()) {

        if(postfix.top() == "+"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            val2 = result.back();
            result.pop_back();

            result.push_back(val2+val1);
        }else if(postfix.top() == "-"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            val2 = result.back();
            result.pop_back();

            result.push_back(val2-val1);
        }else if(postfix.top() == "*"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            val2 = result.back();
            result.pop_back();

            result.push_back(val2*val1);
        }else if(postfix.top() == "/"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            val2 = result.back();
            result.pop_back();

            result.push_back(val2/val1);
        }else if(postfix.top() == "^"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            val2 = result.back();
            result.pop_back();

            result.push_back(square(val2,val1));
        }else if(postfix.top() == "#"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            result.push_back(square_root(val1)); 
        }else if(postfix.top() == "%"){
            postfix.pop();

            val1 = result.back();
            result.pop_back();

            val2 = result.back();
            result.pop_back();

            result.push_back((int)val2%(int)val1);
        }else if(postfix.top() == "!"){
            postfix.pop();
            
            val1 = result.back();
            result.pop_back();

            result.push_back(factorial(val1));
        }else if(zmienne.find(postfix.top())!=zmienne.end()){
            result.push_back(zmienne[postfix.top()]);
            postfix.pop();
        }else{
            result.push_back(std::stod(postfix.top()));
            postfix.pop();
        }
    }
    return result[0];
}

void executeInstruction(std::vector<Instruction> &instr, int &i){
    switch(instr[i].name){
        case WYPISZ:{
            std::cout<<calculatePostfix(infix2postfix(instr[i].equation))<<"\n";
            break;
        }
        case JEZELI:{
            if(instr[i].condition == 0) i++;
            break;
        }
        case PETLA_WHILE:{
            std::string a = instr[i].variable;
            i+=2;
            int control = 1;
            int execute = 2;
            while(zmienne[a]!=0){
                executeInstruction(instr, control);
                executeInstruction(instr, execute);
            }
            break;
        }
        case PRZYPISZ:{
            double val = calculatePostfix(infix2postfix(instr[i].equation));
            if(zmienne.find(instr[i].variable)!=zmienne.end()){
                zmienne[instr[i].variable] = val;
                std::cout<<"zmienna " << instr[i].variable << " istnieje, przypisano do niej wartosc " << zmienne[instr[i].variable] << "\n";
			}
			else{
                zmienne.emplace(std::make_pair(instr[i].variable, val));				
                std::cout<<"zmienna " << instr[i].variable << " nie istnieje, utworzono ja i przypisano do niej wartosc " <<zmienne[instr[i].variable] << "\n";
			}
            break;
        }
    }
}