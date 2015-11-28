//State
final int START = 0;
final int PLAY  = 1;
final int WIN   = 2;
final int LOSE  = 3;
int NowState = START;

//Player
float PlayerX;
float PlayerY;
float PlayerSpeed = 5;
boolean upPressed    = false;
boolean downPressed  = false;
boolean leftPressed  = false;
boolean rightPressed = false;
int PlayerHp = 20;

//Background 
float BGX1 = 0;
float BGX2 = 0;
float BGSpeed = 3;

//Emeny
float EnemyX = 0;
float EnemyY = 0;
float EnemySpeed = 4;
float EnemyState = 1;
int[] EnemyAlive = {1,1,1,1,1,1,1,1};
int[] Enemyflame = {0,0,0,0,0,0,0,0};
float[] flameX = {0,0,0,0,0,0,0,0};
float[] flameY = {0,0,0,0,0,0,0,0};

//Treasure
float TreasureX = 0;
float TreasureY = 0;

//Shoot
int shootnum = 0;
float[] shootX = {0,0,0,0,0};
float[] shootY = {0,0,0,0,0};

//Picture
PImage start1,start2;
PImage bg1,bg2;
PImage fighter;
PImage enemy;
PImage hp;
PImage treasure;
PImage end1,end2;
PImage[] flames=new PImage[5];
PImage shoot;

void setup () 
{
  //Picture Load
  start1    = loadImage("img/start1.png");
  start2    = loadImage("img/start2.png");
  bg1       = loadImage("img/bg1.png");
  bg2       = loadImage("img/bg2.png");
  fighter   = loadImage("img/fighter.png");
  enemy     = loadImage("img/enemy.png");
  hp        = loadImage("img/hp.png");
  treasure  = loadImage("img/treasure.png");
  end1      = loadImage("img/end1.png");
  end2      = loadImage("img/end2.png");
  for(int i=0; i<5; i++)
    flames[i] =loadImage("img/flame"+(i+1)+".png");
  shoot      = loadImage("img/shoot.png");
  
  //Interface
  size(640, 480) ;
  image(start1,0,0);
  
  //shoot location
  for(int i=0; i<5; i++)
  {
    shootX[i] = 2*width;
    shootY[i] = 2*height;
  }
    
}

void draw() 
{
  switch (NowState)
  {
    case START:
      if(mouseX>205 && mouseX<460 && mouseY>375 && mouseY<415)
      {
        image(start1,0,0);
        if(mousePressed)            
        {
          //Reset Player location 
          PlayerX = width - 50;
          PlayerY = height/2;
          
          //Reset Background location
          BGX2 = BGX2-width;
          
          //Reset Enemy location
          EnemyY = random(height-50);
          
          //Reset Treasure location
          TreasureX = random(width-50);
          TreasureY = random(height-50);
          
          NowState = PLAY;
        }
      }
      else
        image(start2,0,0);
      break;
    case PLAY:
      //Background 
      image(bg1,BGX1,0);
      image(bg2,BGX2,0);
      BGX1 += BGSpeed;
      BGX2 += BGSpeed;
      if(BGX1>width)
        BGX1 = 0-width;
      if(BGX2>width)
        BGX2 = 0-width;
        
      //Player HP
      colorMode(RGB);
      fill(255,0,0);
      switch (PlayerHp)
      {
        case 100:
        {
          rect(5,5,200,23);
          break;
        }
        case 90:
        {
          rect(5,5,180,23);
          break;
        }
        case 80:
        {
          rect(5,5,160,23);
          break;
        }
        case 70:
        {
          rect(5,5,140,23);
          break;
        }
        case 60:
        {
          rect(5,5,120,23);
          break;
        }
        case 50:
        {
          rect(5,5,100,23);
          break;
        }
        case 40:
        {
          rect(5,5,80,23);
          break;
        }
        case 30:
        {
          rect(5,5,60,23);
          break;
        }
        case 20:
        {
          rect(5,5,40,23);
          break;
        }
        case 10:
        {
          rect(5,5,20,23);
          break;
        }
      }
      image(hp,0,0);
      
      //Player move
      if (upPressed) 
        PlayerY -= PlayerSpeed;
      if (downPressed) 
        PlayerY += PlayerSpeed;
      if (leftPressed) 
        PlayerX -= PlayerSpeed;
      if (rightPressed) 
        PlayerX += PlayerSpeed;
      
      // boundary detection
      if(PlayerX>width-50)
        PlayerX=width-50;
      if(PlayerX<0)
        PlayerX=0;
      if(PlayerY>height-50)
        PlayerY=height-50;
      if(PlayerY<0)
        PlayerY=0;
      
      //Player Location
      image(fighter,PlayerX,PlayerY);
        
      //Enemy
      if(EnemyState==1)
      {
        //Enemy Location
        float[] AllEnemyLocationX = {EnemyX,EnemyX-80,EnemyX-160,EnemyX-240,EnemyX-320};
        float[] AllEnemyLocationY = {EnemyY,EnemyY,EnemyY,EnemyY,EnemyY};
        for(int i=0;i<5;i++)
          if(EnemyAlive[i] ==1)
            image(enemy,AllEnemyLocationX[i],AllEnemyLocationY[i]);
          
        //Collision (Player and Enemy)
        for(int i=0;i<5;i++)
            if(dist(PlayerX,PlayerY,AllEnemyLocationX[i],AllEnemyLocationY[i])<50 && EnemyAlive[i] ==1)
            {
              PlayerHp = PlayerHp-20;
              EnemyAlive[i] = 0;
              flameX[i] = AllEnemyLocationX[i];
              flameY[i] = AllEnemyLocationY[i];
              Enemyflame[i]+=1;
            }  
            
        //Collision (shoot and Enemy)
        for(int i=0;i<5;i++)
          for(int j=0;j<5;j++)
            if(dist(shootX[j]+25,shootY[j]+25,AllEnemyLocationX[i]+25,AllEnemyLocationY[i]+25)<40 && EnemyAlive[i] ==1)
            {
              
              EnemyAlive[i] = 0;
              flameX[i] = AllEnemyLocationX[i];
              flameY[i] = AllEnemyLocationY[i];
              Enemyflame[i]+=1;
              shootX[j] = shootX[shootnum-1];
              shootY[j] = shootY[shootnum-1];
              shootX[shootnum-1] = 2*width;
              shootY[shootnum-1] = 2*height;
              shootnum--;
            }  
        
        //Enemy boundary detection
        if(EnemyX-320>width)
        {
          EnemyX = 0;
          EnemyY = random(height-210);
          for(int i=0;i<5;i++)
          {
            EnemyAlive[i] = 1;
            Enemyflame[i] = 0;
          }
          EnemyState+=1;
        }
      }
     if(EnemyState==2)
      {
        //Enemy Location
        float[] AllEnemyLocationX = {EnemyX,EnemyX-80,EnemyX-160,EnemyX-240,EnemyX-320};
        float[] AllEnemyLocationY = {EnemyY,EnemyY+40,EnemyY+80,EnemyY+120,EnemyY+160};
        for(int i=0;i<5;i++)
          if(EnemyAlive[i] ==1)
            image(enemy,AllEnemyLocationX[i],AllEnemyLocationY[i]);
          
        //Collision (Player and Enemy)
        for(int i=0;i<5;i++)
            if(dist(PlayerX,PlayerY,AllEnemyLocationX[i],AllEnemyLocationY[i])<50 && EnemyAlive[i] ==1)
            {
              PlayerHp = PlayerHp-20;
              EnemyAlive[i] = 0;
              flameX[i] = AllEnemyLocationX[i];
              flameY[i] = AllEnemyLocationY[i];
              Enemyflame[i]+=1;
            }  
            
        //Collision (shoot and Enemy)
        for(int i=0;i<5;i++)
          for(int j=0;j<5;j++)
            if(dist(shootX[j]+25,shootY[j]+25,AllEnemyLocationX[i]+25,AllEnemyLocationY[i]+25)<40 && EnemyAlive[i] ==1)
            {
              
              EnemyAlive[i] = 0;
              flameX[i] = AllEnemyLocationX[i];
              flameY[i] = AllEnemyLocationY[i];
              Enemyflame[i]+=1;
              shootX[j] = shootX[shootnum-1];
              shootY[j] = shootY[shootnum-1];
              shootX[shootnum-1] = 2*width;
              shootY[shootnum-1] = 2*height;
              shootnum--;
            }  
            
        //Enemy boundary detection
        if(EnemyX-320>width)
        {
          EnemyX = 0;
          EnemyY = random(140,height-190);
          for(int i=0;i<5;i++)
          {
            EnemyAlive[i] = 1;
            Enemyflame[i] = 0;
          }
          EnemyState+=1;
        }
      }
      if(EnemyState==3)
      {
        //Enemy Location
        float[] AllEnemyLocationX = {EnemyX,EnemyX-70,EnemyX-70,EnemyX-140,EnemyX-140,EnemyX-210,EnemyX-210,EnemyX-280};
        float[] AllEnemyLocationY = {EnemyY,EnemyY+70,EnemyY-70,EnemyY+140,EnemyY-140,EnemyY+70,EnemyY-70,EnemyY};
        for(int i=0;i<8;i++)
          if(EnemyAlive[i] ==1)
            image(enemy,AllEnemyLocationX[i],AllEnemyLocationY[i]);
          
        //Collision (Player and Enemy)
        for(int i=0;i<8;i++)
            if(dist(PlayerX,PlayerY,AllEnemyLocationX[i],AllEnemyLocationY[i])<50 && EnemyAlive[i] ==1)
            {
              PlayerHp = PlayerHp-20;
              EnemyAlive[i] = 0;
              flameX[i] = AllEnemyLocationX[i];
              flameY[i] = AllEnemyLocationY[i];
              Enemyflame[i]+=1;
            }  
            
        //Collision (shoot and Enemy)
        for(int i=0;i<8;i++)
          for(int j=0;j<5;j++)
            if(dist(shootX[j]+25,shootY[j]+25,AllEnemyLocationX[i]+25,AllEnemyLocationY[i]+25)<40 && EnemyAlive[i] ==1)
            {
              
              EnemyAlive[i] = 0;
              flameX[i] = AllEnemyLocationX[i];
              flameY[i] = AllEnemyLocationY[i];
              Enemyflame[i]+=1;
              shootX[j] = shootX[shootnum-1];
              shootY[j] = shootY[shootnum-1];
              shootX[shootnum-1] = 2*width;
              shootY[shootnum-1] = 2*height;
              shootnum--;
            }  
            
        //Enemy boundary detection
        if(EnemyX-320>width)
        {
          EnemyX = 0;
          EnemyY = random(height-50);
          for(int i=0;i<8;i++)
          {
            EnemyAlive[i] = 1;
            Enemyflame[i] = 0;
          }
          EnemyState = 1;
        }
      }
      
      //Enemy move
      EnemyX += EnemySpeed; 
      
      //Enemy flame
      for(int i=0;i<8;i++)
      {
        if(Enemyflame[i]>=1)
        {
          for(int j=0;j<5;j++)
          {
            if(Enemyflame[i]==j)
              image(flames[j],flameX[i],flameY[i]);
          }
        }
      }
      if(frameCount%10==0)
      {
        for(int i=0;i<8;i++)
        {
          if(Enemyflame[i]>=1)
            Enemyflame[i]++;
        }
      }
  
      //Treasure
      image(treasure,TreasureX,TreasureY);
      
      //Collision (Player and Treasure)
       if(dist(PlayerX,PlayerY,TreasureX,TreasureY)<50)
      {
        if(PlayerHp<100)
            PlayerHp = PlayerHp+10;
          TreasureX = random(width-50);
          TreasureY = random(height-50);
      }  
      
      //shoot
      if(shootnum >0)   
        for(int i=0;i<shootnum;i++)
        {      
            image(shoot,shootX[i],shootY[i]);
            shootX[i]-=5;      
        }
      
      
      
  
      //GAMEOVER
      if(PlayerHp <= 0)
        NowState = LOSE;
      break;
    case WIN:
      //It's no way to win.  So sad.
      break;
    case LOSE:
      if(mouseX>205 && mouseX<440 && mouseY>305 && mouseY<350)
      {
        image(end1,0,0);
        if(mousePressed)            
        {
          //Reset Player 
          PlayerHp = 20;
          PlayerX = width - 50;
          PlayerY = height/2;
          
          //Reset Background 
          BGX2 = 0-width;
          BGX1 = 0;
          
          //Reset Enemy 
          EnemyX = 0;
          EnemyY = random(height-50);
          for(int i=0;i<8;i++)
          {
            EnemyAlive[i] = 1;
            Enemyflame[i] = 0;
          }
          EnemyState = 1;
          
          //Reset Treasure 
          TreasureX = random(width-50);
          TreasureY = random(height-50);
          
          //Reset shoot
          shootnum = 0;
          
          NowState = PLAY;
        }
      }
      else
        image(end2,0,0);
      break;
      
  }
}
void keyPressed()
{
   if (key == CODED) 
   { 
    switch (keyCode) 
    {
      case UP:
        upPressed    = true;
        break;
      case DOWN:
        downPressed  = true;
        break;
      case LEFT:
        leftPressed  = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
  
  //shoot
  if(NowState == PLAY)
    if(keyCode == ' ')    
      if(shootnum <5)
      {
        shootnum++;                       
          shootX[shootnum-1] = PlayerX-40;
          shootY[shootnum-1] = PlayerY+10;         
      }
      
  //shoot boundary detection
  for(int i=0;i<5;i++)
  {
    if(shootX[i]<0)
    {
      shootX[i] = shootX[shootnum-1];
      shootY[i] = shootY[shootnum-1];
      shootX[shootnum-1] = 2*width;
      shootY[shootnum-1] = 2*height;
      shootnum--;
    }
  }
}
void keyReleased()
{
   if (key == CODED) 
   {
      switch (keyCode) 
      {
        case UP:
          upPressed    = false;
          break;
        case DOWN:
          downPressed  = false;
          break;
        case LEFT:
          leftPressed  = false;
          break;
        case RIGHT:
          rightPressed = false;
          break;
    }
  }
}
