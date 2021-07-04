 __asm__(".code16gcc\n");
 __asm__("mov $0,%eax\n");
 __asm__("mov %ax,%ds\n");
 __asm__("mov %ax,%es\n");
 __asm__("jmpl $0,$_snake\n");
 #include "stdio.c"

int x[100], y[100];   //record the position of snake
int food_x, food_y;  // record the position of food
char overa[11] = "Game Over!";
char overb[27] = "Press any button to quit.";
int food_illegal(int, int); // judge whether the food is illegal
void print_score(int);    // print the score int num
void over();       //print game over
void draw_boundary();   // draw the boundary of the game
void snake();   // game
int is_dead(int, int);     //judge whether the snake is is_dead 
void creatfood(int,int);    //create food in rand


void snake() 
{
  clear();
  int d = 4, len = 5, score = 0;
  //d is initial ;len is the length;  score is the num you get
  draw_boundary();
  char t = 0;  // read the input
  int head = 4, tail = 0;
  for(int i = 0; i <= 4; i++) // initial snake
  { 
      x[i] = 8;
      y[i] = 30 + i;
      output_pos_col(x[i],y[i],254,2);
  }
  creatfood(head, tail);
  
  while(1) 
  {
    x[(head + 1) % 100] = x[head];
    y[(head + 1) % 100] = y[head];
    head = (head + 1) % 100;
   
    if(d==1)       x[head]--;
    else if(d==2)  x[head]++;
    else if(d==3)  y[head]--;
    else if(d==4)  y[head]++;
    for(int i = 50000 ; i>=0 ; i--)
        for(int j = 0 ; j < 1000 ; j++ ); //delay
    output_pos_col(x[head],y[head],254,2);    
    if(x[head] == food_x && y[head] == food_y) 
    {
      creatfood(head, tail);
      score++;
    }
    else 
    {
      output_pos_col(x[tail],y[tail],' ',4);      
      tail = (tail + 1) % 100;
    }
    print_score(score);
    t = isinput();
    if(t!=0){
      if(t == 'w' && d != 2) d = 1;
      else if(t == 's' && d != 1) d = 2;
      else if(t == 'a' && d != 4) d = 3;
      else if(t == 'd' && d != 3) d = 4;
      t = 0;
    }
    if(is_dead(head, tail))
      break;
  }
  over();
  while(!isinput());
  clear();
  return;
}
void draw_boundary()
{
  for(int i = 4 ; i <= 76 ; i++ )
  {
    output_pos_col(4,i,219,4);
    output_pos_col(21,i,219,4);
  }
  for(int i = 4 ; i <= 21 ; i++ )
  {
    output_pos_col(i,4,219,4);                          
    output_pos_col(i,76,219,4);
  }
}

int is_dead(int head, int tail){
  if(x[head] <= 4 || x[head] >= 21 || y[head] <= 4 || y[head] >= 76)
    return 1;
  for(int i = tail; i != head; i = (i + 1) % 100) 
  {// hit the body
    if(x[head] == x[i] && y[head] == y[i])
      return 1;
  }
    return 0;
}

void creatfood(int head, int tail) {
  food_x = (time() + 7) % 16 + 5;
  food_y = time() % 71 + 5;
  while(food_illegal(head, tail))
  {
    food_x = time() % 16 + 5;
    food_y = time() % 71 + 5;
  }
    output_pos_col(food_x,food_y,2,14);  
}


void print_score(int score) {
  setgb(3,68);
  printstr("SCORE:");
  setgb(3,74);
  printint(score);
}

void over(){
    setgb(12,25);
    prints_color(overa,0x0E);
    setgb(13,25);
    prints_color(overb,0x0E);
}

int food_illegal(int head, int tail) {
  for(int i = tail; i != head; i = (i + 1) % 100)
  {
    if(food_x == x[i] && food_y == y[i])
      return 1;
  }
  if(food_x == x[head] && food_y == y[head])
    return 1;
  return 0;
}
