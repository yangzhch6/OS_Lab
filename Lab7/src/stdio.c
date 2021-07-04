#ifndef _MY_STDIO_
#define _MY_STDIO_

static unsigned int nextnum = 1;
int STACK_TABLE[5];
int EMPTY_TABLE[5];

#define Empty 0
#define Ready 1
#define Block 2
#define Run 3
#define Exit 4

typedef struct pcb
{
	int ax;
	int bx;
	int cx;
	int dx;
	int si;
	int di;
	int bp;
	int es;
	int ds;
	int ss;
	int sp;
	int ip;
	int cs;
	int flags;
	int status;
	int id;
    int f_id;
}pcb;
struct pcb PCBlist[5];
struct pcb* CurrentProc = &PCBlist[0];
int Cur_num = 0;


extern char input();        //input and display'
extern int getgb(); // get the position of g
extern void setgb(int row,int col); //extern void setpos(int x,int y);
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
//extern void string_color(char*,int,int,int,int);
extern void loadp(int cylinder , int head , int begin , int count,int offset,int segment);
//load the programe into cpu
extern void clear_pos(int xa,int ya,int xb,int yb);//clear the postion
extern int getdate();// get the date
extern int getnow();// get the time of now
extern void change_int08h();
extern void change_int09h();


void int_08h_overide();
void int_09h_overide();

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


extern int fork();
extern char wait();
extern void exit(int);
extern void INT33_to_36();
extern int stackcopy(int , int , int);
void Schedule();
void delete_process();
void do_fork();
void do_exit();
void do_wait();
void block();
void wakeup();
void memcopy();


void what(){
    int x = 3;
    printint(x);
}


void Schedule()
{
    Cur_num = CurrentProc->id;
	if(CurrentProc->status == Exit)
		CurrentProc->status = Empty;		//exit进程
	else if(CurrentProc->status == Run)
		CurrentProc->status = Ready;		//正常进程切换

	while(1){
		Cur_num = (Cur_num + 1) % 5;
		if(PCBlist[Cur_num].status == Ready){
			CurrentProc = &PCBlist[Cur_num];
			CurrentProc->status = Run;
			break;
		}
	}
}
void stop_pro()
{
    for(int i = 1 ; i < 5 ; i++)
        PCBlist[i].status = 0;
}
void pushPCB(int index,int offset)
{
	PCBlist[index].cs = index*0x1000;
    PCBlist[index].es = PCBlist[index].cs;
    PCBlist[index].ds = PCBlist[index].cs;
    PCBlist[index].ss = PCBlist[index].cs;
	PCBlist[index].flags = 512;
	PCBlist[index].status = Ready;
    PCBlist[index].ax = 0;
    PCBlist[index].bx = 0;
    PCBlist[index].cx = 0;
    PCBlist[index].dx = 0;
    PCBlist[index].si = 0;
    PCBlist[index].di = 0;
    PCBlist[index].bp = 0;
    PCBlist[index].ip = offset;
    PCBlist[index].sp = 0x2000;
    PCBlist[index].id = index;
    PCBlist[index].f_id = -1;
	STACK_TABLE[index] = 0x2000;
}
void initialPCB()
{
    PCBlist[0].ax = 0;
    PCBlist[0].bx = 0;
    PCBlist[0].cx = 0;
    PCBlist[0].dx = 0;
    PCBlist[0].si = 0;
    PCBlist[0].di = 0;
    PCBlist[0].bp = 0;
    PCBlist[0].es = 0;
    PCBlist[0].ds = 0;
    PCBlist[0].cs = 0;
    PCBlist[0].ss = 0;
    PCBlist[0].sp = 0;
    PCBlist[0].ip = 0;
    PCBlist[0].flags = 512;
    PCBlist[0].status = Ready;
    PCBlist[0].id = 0;
    PCBlist[0].f_id = -1;
	for(int i = 1 ; i < 5 ; i++){
		PCBlist[i].status=Empty;
		EMPTY_TABLE[i]=0xffff;
	}
}
void delete_process(){
	PCBlist[1].status=0;
	PCBlist[2].status=0;
	PCBlist[3].status=0;
	PCBlist[4].status=0;
}


void do_fork(){
    struct pcb * son_p = CurrentProc ;
	int son_id = 0;
	for(son_id = 1 ; son_id < 5 ; son_id++)  if(PCBlist[son_id].status == Empty) break;
    if(son_id == 5) CurrentProc->ax = -1;//进程已满，创建子进程失败，返回-1；
    else {
        printstr("father process id:");printint(CurrentProc->id);CR();
        printstr("son process id:");printint(son_id);CR();
        son_p = &PCBlist[son_id];   // p 指向 子进程PCB
        memcopy(CurrentProc, son_p); 
        son_p->f_id = CurrentProc->id;
        CurrentProc->ax = son_id; //设置父进程fork返回值
        son_p->status = Ready;
        son_p->ax = 0; //设置子进程fork返回值
        son_p->id = son_id; 

        int key = son_p->cs >> 12;  // cs段寄存器的值前4位 如0x1000
        son_p->sp = EMPTY_TABLE[key];
        EMPTY_TABLE[key] -= 0x1000;
        STACK_TABLE[son_id] = son_p->sp;
        son_p->sp = stackcopy(CurrentProc->sp , STACK_TABLE[CurrentProc->id] , son_p->sp); 
        return;
    }
}

void do_exit(int s){
	CurrentProc->status = Exit;//结束当前进程
	if(CurrentProc->f_id != -1 && PCBlist[CurrentProc->f_id].status == Block){
		wakeup(CurrentProc->f_id);
		if (s == 0)
			PCBlist[CurrentProc->f_id].ax = 'T';
		else
			PCBlist[CurrentProc->f_id].ax = 'F';
	}
	__asm__ ("int $0x8\n"); // 调用时钟中断
}

void wakeup(int id){
	PCBlist[id].status = Ready;
}

void block(int id){
	PCBlist[id].status = Block;
}

void do_wait(){
	__asm__ ("cli\n");
	block(CurrentProc->id);
	Schedule();
}

void memcopy(struct pcb* father, struct pcb* son){
	son->bx = father->bx;
	son->cx = father->cx;
	son->dx = father->dx;
	son->si = father->si;
    son->di = father->di;
	son->bp = father->bp;
	son->flags = father->flags;
	son->es = father->es;
    son->ds = father->ds;
    son->cs = father->cs;
	son->ss = father->ss;
	son->ip = father->ip;
}


//***********************************************//
//*************基本输入输出功能*******************//
//***********************************************//
static int ouch_color = 1;
void int_09h_overide()
{
    ouch_color++;
    if( ouch_color >= 20 ) ouch_color = 2;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    setgb(23,76);
    prints_color("OUCH",ouch_color/2);
    setgb(ox,oy);   
}
static int num = 0;
static char time_c[4] = {'|','-','/','\\'};
void int_08h_overide()
{
    num++;
    if(num == 60) num = 0;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;  
    setgb(24,76);
    printint(num);
    setgb(24,78);
    output(time_c[num%4]);
    setgb(ox,oy); 
}
void prints_color(char *str, int color)
{
    int length = strlen(str);
    int i = 0 ;
    for(i = 0; i<length; i++)
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
        if(alp == '\r') //if CR
        {
            str[i-1] = '\0';
            CR();
            break;
        }
        else if(alp == 8)// if backspace
        {
            if(i == 1)//if the pos is 1, do not backspace 
            {
                str[0] = str[1] = '\0';
                i = 0;
                next();
                continue;
            }              //inspect the string--command
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
    if(num == 0){
        output('0');
        return;
    }
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