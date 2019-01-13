#include <iostream>
#include <string>


	struct Instruction{
		int name;    		
		std::string variable="";
		std::string equation="";
        int condition;
        


        Instruction(int name, std::string equation) : name(name), equation(equation){};

        Instruction(int name, int condition, int marker) : name(name), condition(condition){};

        Instruction(int name, std::string variable, std::string equation) : name(name), variable(variable), equation(equation){};
	};