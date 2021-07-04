#ifndef _MY_STDIO_
#define _MY_STDIO_
static unsigned int nextnum = 1;

extern char input();        //input and display'
extern void setgb(int row,int col);
//extern int getpos();
//extern void setpos(int x,int y);
extern void output(char alp);   //just output 
extern void backspace();    //back a backspace 
extern void clear();        //clear the line
// the below function is a bit compelicated
extern void changepos(int x,int y,int color,char alp);
extern int isinput();       //scan the board cin
extern void next();         //remain the position of GB
extern void clearin();      //clear the input area  
extern int time();          //get the time
extern void runp();         //run the programe
extern char output_color(const char, int);//print a char with color
extern void loadp(int cylinder , int head , int begin , int count);
//load the programe into cpu

void output_pos_col(int row,int col,char alp,int color);
void CR();                   // CR
int strlen(char *);          // count the length of the stirng   
void printstr(char * str);       // print string    
void scanf(char *);          // scanf string
int compare(char *, char *); // compare if(a==b)  
int rand(); // randing number 
void srand(unsigned seed); 
void printint(int num);      //print a number int
void prints_color(char * str, int color);//print string in color
void srand(unsigned seed ){ nextnum = seed; }

void prints_color(char *str, int color)
{
    int length = strlen(str);
    int i = 0 ;
    for(i = 0; i<length ; i++)
        output_color(str[i],color);
}

int rand()
{
    nextnum = nextnum*29546 + 12345;
    return (unsigned)next;
} 

void CR()
{
    output('\r');
    output('\n');
}
void printstr(char * str)//output string
{
    int length = strlen(str);
    int i = 0 ;
    for(i = 0; i<length ; i++)
        output(str[i]);
}
int strlen(char * str)
{
    int i = 0 ;
    char * alp = str;
    for(i = 0 ;  ; i++,alp++)
    {
        if(*alp == '\0')
            break;
    }
    return i;
}
void scanf(char *str)
{
    char alp;
    int i = 0 ;
    while(1)
    {
        alp = input(); //bl ,  mov bl,al
        str[i++] = alp;
        if(alp == '\r')
        {
            str[i-1] = '\0';
            CR();
            break;
        }
        else if(alp == 8)
        {
            if(i == 1)
            {
                str[0] = str[1] = '\0';
                i = 0;
                next();
                continue;
            }
            str[--i]='\0';
            str[--i]='\0';
            backspace();
        }
    }
    str[i] = '\0';
}
int compare(char * a , char * b )
{
    int length_a = strlen(a);
    int length_b = strlen(b);
    if(length_a != length_b)
        return 0;
    int i = 0 ;
    for(i = 0 ; i<length_a ; i++)
    {
        if(a[i] != b[i])
            return 0;    
    }
    return 1;
}

void printint(int num)
{
    int digit[5];
    for(int i =0 ; i < 5 ; i++)
    {
        digit[4-i] = num%10;
        num = num/10;
    }
    int isprint = 0; 
    for(int i = 0 ; i <=4 ; i++)
    {
        if(isprint == 0 && digit[i] != 0)
            isprint = 1;
        if(isprint)  output('0'+digit[i]);
    }
}

void output_pos_col(int row,int col,char alp,int color)
{
    setgb(row,col);
    output_color(alp,color);
}

#endif