 __asm__(".code16gcc\n");
 __asm__("mov %cs,%ax\n");
 __asm__("mov %ax,%ds\n");
 __asm__("mov %ax,%es\n");
 __asm__("call __main\n");
 __asm__("lret\n");


#include "stdio.c"
char str[80]="129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr=0;
int _main() {
	int pid;   
	char ch;
	pid = fork();
	if (pid == -1) 
		printstr("error in fork!");
    if (pid)  {   
    	ch = wait(); 
    	output(ch);
    	CR();
    	char* message = "The length of the string is ";
    	printstr(message);
    	printint(LetterNr);
    	CR();
    } 
	else {   
		LetterNr = strlen(str);   
		exit(0);
	}
	while(1);
	return 0;
}	