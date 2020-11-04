// Output initial instructions and definitions
void initialize_out() {
	fprintf(yyout, ".globl main:\nmain:");
}

void print_instr(char* str) {
	fprintf(yyout, "\t%s\n", str);
}

void push(int val) {
	stack[st_top++] = val;
}
int get_top() {
	return stack[st_top-1];
}
void pop() {
	st_top--;
}

// Push $a0 onto stack
void cgen_push() {
	print_instr("sw $a0 0($sp)");
	print_instr("addiu $sp $sp -4");
}
// Pop from stack
void cgen_pop() {
	print_instr("addiu $sp $sp  4");
}

void cgen_int() {
	char str[100];
	// Load immediate with INT value
	sprintf(str, "li $a0 %d", yylval);
	print_instr(str);
}
void cgen_var() {
	char str[100];
	// Load address of vars array and load appropriate variable word in $a0
	print_instr("la $t0 vars");
	sprintf(str, "lw $a0 %d($t0)", 4*yylval);
	print_instr(str);
}
// Generate code for assignment
void cgen_assign(int var_id) {
	char str[100];
	// Load address of vars array
	print_instr("la $t0 vars");

	// Store value at $a0 at the appropriate location in array
	sprintf(str, "sw $a0 %d($t0)", 4*var_id);
	print_instr(str);
	vars[var_id] = get_top();
}
// Generate code for printing a value
void cgen_print() {
	// Print value
	print_instr("li $v0 1");
	print_instr("syscall");

}
// Generate code for reading an input into a variable
void cgen_input(int var_id) {
	// Syscall to print input prompt
	print_instr("la	$a0 prompt");
	print_instr("syscall");

	char str[100];

	// Store value at $v0 from input at the appropriate location in array
	sprintf(str, "sw $v0 %d($t0)", 4*var_id);
	print_instr(str);
	vars[var_id] = get_top();
	print_instr("move $a0 $t0");
}

// Multiply $a0 by -1
void cgen_neg() {
	print_instr("li $t0 -1");
	print_instr("mul $a0 $a0 $t0");
}

// Perform binary operation between two operands
void cgen_binop(char op) {
	// Operate value in $a0 with value on top of stack
	print_instr("lw $t0 4($sp)");
	cgen_pop();
	char str[100] = "\0";
	switch (op) {
		case '+':
			sprintf(str, "add");
			break;
		case '-':
			sprintf(str, "sub");
			break;
		case '*':
			sprintf(str, "mul");
			break;
		case '&':
			sprintf(str, "and");
			break;
		case '|':
			sprintf(str, "or");
			break;
	}
	strcat(str, " $a0 $t0 $a0");
	print_instr(str);
}
// Perform devision between two operands
void cgen_div() {
	// Operate value in $a0 with value on top of stack
	print_instr("lw $t0 4($sp)");
	cgen_pop();
	print_instr("div $t0 $a0");
	print_instr("mflo $a0");
}

void cgen_array(){
	int base_address = 100;
	char str[100];
	// initialization of array
	print_instr("lui $s0, base_address" );   //  upper
	sprintf(str,"ori $s0, $s0, %d*base_address",yyval); //  lower
	print_instr(str);
}
