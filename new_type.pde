import http.requests.*;

int L = 1408, H = 640;
int nbCubes = 150;
int nbCubesW = 100;

int sizeBelt = 12;
int base = 18, max = 20, min = 10;
int baseW = 18, maxW = 10, minW = 15;
int sizeCube = 20;
int posCam = -1300;
int nbIn = 0, nbFixe = 0;

Cube[] Cubes = new Cube[nbCubes];
WireCube[] WireC = new WireCube[nbCubesW];

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
      else
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
        }
      else if (Cubes[i].goIn)
        {
          tranRota(Cubes[i].speedRota);
          Cubes[i].in();
          Cubes[i].display();
        }
      else if (Cubes[i].fromTable)
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
/*
  directionalLight(255, 255, 255, 0.050000012, -0.6576705, -1);
  directionalLight(255, 255, 255, 0.02352941, 0.43323863, -1);
  directionalLight(255, 255, 255, 0.5323529, 0.42471594, -1);
  directionalLight(255, 255, 255, 0.12647057, -0.024147749, 1);
  directionalLight(255, 255, 255, -0.27647054, 0.009943187, 1);
*/
  drawWire();
  drawSido();
}

void createCubes()
{
  int i = 0;

  while (i != nbCubes)
  {
    Cubes[i] = new Cube(random(0.0009, 0.003), random(0.0009, 0.003), 
    ((i * base) > 700 ? (i * min) :
    (i * base) == 0 ? 1000 :
    (i * max)), 0);
    Cubes[i].isPop = false;
    i++;
  }
  i = 0;
  while (i != nbCubesW)
  {
    WireC[i] = new WireCube(random(0.0009, 0.003), random(0.0009, 0.003), 
    ((i * baseW) > 700 ? (i * minW) :
    (i * baseW) == 0 ? 1000 :
    (i * maxW)), 0);
    i++;
  }
}

void setup()
{
  size(L, H, P3D);
  createCubes();
  load();
}

boolean loadValue = true;

void draw()
{
  background(0);
  if (second() % 2 == 0 && loadValue)
  {
    loadValue = false;
    thread("load");
  } 
  else if (second() % 2 != 0)
    loadValue = true;
  drawCubes();
}

