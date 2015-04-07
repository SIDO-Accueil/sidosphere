import http.requests.*;

int L = 1408, H = 640;
int nbCubes = 150;

int sizeBelt = 12;
int base = 15, max = 50, min = 10;
int baseW = 12, maxW = 50, minW = 15;
int sizeCube = 20;
int posCam = -1300;
int nbCubesW = 100;

Cube[] Cubes = new Cube[nbCubes + 1];
WireCube[] WireC = new WireCube[nbCubesW + 1];
/*
Cube[] CubesDrawing = null;
WireCube[] WireCDrawing = null;
*/
boolean loadValue = true;
MySQL        qzeMysql;
String       apple_percent;
String       android_percent;
String       win_percent;
String       autre_percent;
float[]      gpercent = new float[11];
int          TEXT_SIZE = 16;
int          percent_offset = 10;
float        multH = 0.85;
PFont font;

String User;
String Txt;

void tranRota(float value)
{
  translate(width / 2, height / 2, posCam);
  rotateY(frameCount * value);
}

void drawWire()
{
  int i = 0;

  while (i != nbCubesW)
  {
    pushMatrix();
    rotateX(WireC[i].axeRota * 0.02);
    if (WireC[i].id != 0)
    {
      tranRota(WireC[i].speedRota);
      if (WireC[i].isPop)
        WireC[i].popWireCube();
      else if (WireC[i].goOut)
      {
        WireC[i].out();
        WireC[i].tranShape(WireC[i].cubeTranZ, WireC[i].cubeTranX);
        WireC[i].display();
      } else
      {
        WireC[i].tranShape(WireC[i].cubeTranZ, WireC[i].cubeTranX);
        WireC[i].display();
      }
    }
    i++;
    popMatrix();
  }
}

void drawSido()
{
  int i = 0;
 

  while (i != nbCubes)
  {
    pushMatrix();
    rotateX(Cubes[i].axeRota * 0.02);
    if (Cubes[i].id != null)
    {
      if (Cubes[i].goOut)
      {
        tranRota(Cubes[i].speedRota);
        Cubes[i].out();
        Cubes[i].display();
      } else if (Cubes[i].goIn)
      {
        tranRota(Cubes[i].speedRota);
        Cubes[i].in();
        Cubes[i].display();
      } else if (Cubes[i].fromTable)
        Cubes[i].popDown();
      else
      {
        tranRota(Cubes[i].speedRota);
        Cubes[i].display();
      }
    }
    i++;
    popMatrix();
  }
}

void drawCubes()
{  
  int i = 0;

  directionalLight(255, 255, 255, 0.050000012, -0.6576705, -1);
  directionalLight(255, 255, 255, 0.02352941, 0.43323863, -1);
  directionalLight(255, 255, 255, 0.5323529, 0.42471594, -1);
  directionalLight(255, 255, 255, 0.12647057, -0.024147749, 1);
  directionalLight(255, 255, 255, -0.27647054, 0.009943187, 1);

  drawWire();
  drawSido();
}

void createCubes()
{
  int i = 0;

  while (i != nbCubes)
  {
    Cubes[i] = new Cube(random(0.0009, 0.003), random(0.0009, 0.003), 
    ((i * base) > 750 ? (i * (min - 20)) :
    (i * base) > 1000 ? (i * min) :
    (i * base) == 0 ? 1000 :
    (i * max)), 0);
    Cubes[i].isPop = false;
    i++;
  }
  i = 0;
  while (i != nbCubesW)
  {
    WireC[i] = new WireCube(random(0.0009, 0.003), random(0.0009, 0.003), 
    ((i * baseW) > 750 ? (i * (minW - 20)) :
    (i * baseW) > 1000 ? (i * minW) :
    (i * baseW) == 0 ? 1000 :
    (i * maxW)), 0);
    i++;
  }
}

Thread thread1;
Thread thread2;
Thread thread3;

void setup()
{
  size(L, H, P3D);
  createCubes();
  qzeMysql = new MySQL(this, "qze.fr", "sido", "sido", "passwordSido?8!");
  //Inconsolata-13.vlw
  font = loadFont("Inconsolata-13.vlw");
  textFont(font, TEXT_SIZE);

  thread1 = new Thread(new Loader());
  thread1.start();
  thread2 = new Thread(new loadLegend());
  thread2.start();
  thread3 = new Thread(new laodLastTweet());
  thread3.start();
}

void  display_stats() 
{
  float tmp;
  fill(255, 255, 255);

  tmp = gpercent[6] / 3;
  text("SIdÔmes :\n#SIdO :\n#IoT :\nApple iOS :\nAndroid :\nWindows Phone :", 8, height * multH -23, -35);
  text(int(gpercent[3]) + "\n" + int(gpercent[5]) + "\n" + int(gpercent[4]) + "\n" + int(gpercent[0] + tmp) + " %\n" + int(gpercent[1] + tmp) + " %\n" + int(gpercent[2] + tmp) + " %\n", TEXT_SIZE * percent_offset, height * multH-23, -35);
}

void draw()
{
  background(0);

  display_stats();
  drawCubes();
  fill(255, 255, 255);
  text("@" + User + " : " + Txt,  8, 20, -35);
}

