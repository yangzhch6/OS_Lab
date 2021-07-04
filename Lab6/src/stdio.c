#ifndef _MY_STDIO_
#define _MY_STDIO_
static unsigned int nextnum = 1;


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
void Schedule();
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
}pcb;
struct pcb PCBlist[5];
struct pcb* CurrentProc = &PCBlist[0];
int Cur_num = 0;

void Schedule()
{
    Cur_num = CurrentProc->id;
    while(1)
    {
        Cur_num++;
        if(Cur_num>4) Cur_num = 0;
        if(PCBlist[Cur_num].status == 1)
        {
            CurrentProc = &PCBlist[Cur_num];
            return;
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
	//int temp=0x6000;
	PCBlist[index].cs = index/3*0x1000+0x1000;//temp-index*0x1000;
    PCBlist[index].es = PCBlist[index].cs;
    PCBlist[index].ds = PCBlist[index].cs;
    PCBlist[index].ss = PCBlist[index].cs;
	PCBlist[index].flags=512;
	PCBlist[index].status=1;
    //
    PCBlist[index].ax = 0;
    PCBlist[index].bx = 0;
    PCBlist[index].cx = 0;
    PCBlist[index].dx = 0;
    PCBlist[index].si = 0;
    PCBlist[index].di = 0;
    PCBlist[index].bp = 0;
    PCBlist[index].ip = offset;
    PCBlist[index].sp = offset-4;
    PCBlist[index].id = index;
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
    PCBlist[0].status = 1;
    PCBlist[0].id = 0;
}



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
/*______________________________________________

系统功能调用
_______________________________________________*/
extern void change_int34to37();
extern void program_test();
extern void change_int21h();

void int_34_overide();
void int_35_overide();
void int_36_overide();
void int_37_overide();

void int_21h0_overide();//get time
void int_21h0_overide();//input and output string 
void int_21h0_overide();//out put "i love OS"
void int_21h_default();//print wrong information
void test();

void test()
{
    clear();
    change_int34to37();
    change_int21h();
    program_test();
    clear();
}
void int_21h0_overide()
{
    clear(); setgb(0,0);
    int date = getdate();

    int tmp_m = date/256; 
    int month = tmp_m>>4; 
    month = month*10+(tmp_m&=0x000F);

    int tmp_d = date%256;
    int day = tmp_d>>4;
    day = day*10+(tmp_d&=0x000F); 

    int now = getnow();

    int tmp_h = now/256;
    int hour = tmp_h>>4; 
    hour = hour*10+(tmp_h&=0x000F);

    int tmp_n = date%256;
    int minute = tmp_n>>4;
    minute = minute*10+(tmp_n&=0x000F);

    printstr("INT 21h,ah=0");CR();
    prints_color("now time: ",0x0E);
    printstr("2018/");printint(month);output('/');printint(day);
    printstr("  ");
    printint(hour);output(':');printint(minute);
    CR();printstr("press any key to continue");
    input();
}
void int_21h1_overide()
{
    clear();
    setgb(0,0);
    printstr("INT 21h , ah=1:");CR();
    prints_color("input the string:",0x0E);
    char str[100];
    scanf(str); 
    prints_color("output the string:",0x0E);
    prints_color(str,0x0E);CR();
    printstr("press any key to continue");
    input();
}
void int_21h2_overide()
{
    clear();
    setgb(0,0);
    printstr("INT 21h , ah=2:");
    prints_color("I love OS !!!",0x0E);CR();
    printstr("press any key to continue");
    input();
}
void int_21h_default()
{
    clear();
    setgb(0,0);
    prints_color("INT 21h,wrong ah you use, there is only 0,1,2 provided:",0x04);
    CR();printstr("press any key to continue");
    input();
}
void int_34_overide()
{
//    clear(1,1,14,40); //clear the area
    setgb(0,0);
    printstr("INT 34: press 'a' to stop:");CR();
    int pos[2] = {3,7};//x,y
    char info = 'Y';//display info
    int dir[2] = {1,1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'a')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 14) dir[0] = -1;
        if(pos[0] == 1)  dir[0] =  1;
        if(pos[1] == 40) dir[1] = -1;
        if(pos[1] == 1)  dir[1] =  1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
void int_35_overide()
{
//    clear(1,15,14,80); //clear the area
    setgb(0,0);
    printstr("INT 35: press 'b' to stop");CR();
    int pos[2] = {3,70};//x,y
    char info = 'Z';//display info
    int dir[2] = {1,-1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'b')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 14) dir[0] = -1;
        if(pos[0] == 1)  dir[0] =  1;
        if(pos[1] == 41) dir[1] =  1;
        if(pos[1] == 79)  dir[1] =  -1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
void int_36_overide()
{
//    clear(1,15,14,80); //clear the area
    setgb(0,0);
    printstr("INT 36: press 'c' to stop");CR();
    int pos[2] = {20,20};//x,y
    char info = 'C';//display info
    int dir[2] = {-1,-1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'c')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 24) dir[0] = -1;
        if(pos[0] == 15)  dir[0] =  1;
        if(pos[1] == 40) dir[1] =  -1;
        if(pos[1] == 1)  dir[1] =  1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
void int_37_overide()
{
//    clear(1,15,14,80); //clear the area
    setgb(0,0);
    printstr("INT 37: press 'd' to stop");CR();
    int pos[2] = {20,70};//x,y
    char info = 'O';//display info
    int dir[2] = {-1,1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'd')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 24) dir[0] = -1;
        if(pos[0] == 15)  dir[0] =  1;
        if(pos[1] == 41) dir[1] =  1;
        if(pos[1] == 79)  dir[1] =  -1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}


#endif