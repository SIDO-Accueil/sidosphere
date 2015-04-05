float minRota = 0.0005, maxRota = 0.01;

class Cube
{
  float cubeSpeedY, cubeSpeedZ;
  float cubeTranX, cubeTranZ, x, y;
  float colR, colG, colB;
  float speedRota, axeRota;
  float angleMoon = 0;
  Float[] vx = new Float[8];
  Float[] vy = new Float[8];
  Float[] vz = new Float[8];
  float clr, clb, clg, newclr, newclb, newclg;
  int z = 0, asMoon;
  boolean isPop, go;
  boolean fromTable, goOut, goIn, refresh;
  float downY = 1410, downZ = 320;
  String id;

  Cube(float speedY, float speedZ, float tranX, float tranZ)
  {
    this.cubeSpeedY = speedY;
    this.cubeSpeedZ = speedZ;
    this.cubeTranX = tranX;
    this.cubeTranZ = tranZ;
    this.speedRota = random(minRota, maxRota);
    this.axeRota = random(-sizeBelt, sizeBelt);
    this.asMoon = 0;
    this.goOut = false;
    this.isPop = false;
    this.go = false;
    this.x = this.cubeTranX;
    this.y = 0;
    this.fromTable = false;
    this.clr = 0;
    this.clg = 0;
    this.clb = 0;
    this.goOut = false;
    this.goIn = false;
    this.id = null;
    this.refresh = false;
  }

  void setBase(String id, int asMoon, boolean fromTable)
  {
    this.id = id;
    this.asMoon = asMoon;
    this.fromTable = fromTable;
    this.goOut = false;
    this.goIn = false;
  }

  void setGoOut(boolean go)
  {
    this.asMoon = 0;
    this.goOut = false;
    this.isPop = false;
    this.go = false;
    this.x = this.cubeTranX;
    this.y = 0;
    this.fromTable = false;
    this.clr = 0;
    this.clg = 0;
    this.clb = 0;
    this.goOut = false;
    this.goIn = false;
    this.id = null;
  }

  void setColor(float newClr, float newClg, float newClb)
  {
    this.newclr = newClr;
    this.newclg = newClg;
    this.newclb = newClb;
  }

  void addVector(float vx, float vy, float vz, int position)
  {
    this.vx[position] = vx;
    this.vy[position] = vy;
    this.vz[position] = vz;
  }

  void drawMoon()
  {
    rotate(angleMoon, 0, 90, 0);
    translate(35, 0, 35);
    noStroke();
    lights();
    fill(255, 255, 255);
    sphere(5);
    angleMoon += 0.01;
  }

  void drawSidome()
  {
    fill(clr, clg, clb);
    noStroke();

    beginShape(QUADS);
    vertex(vx[0], vy[0], vz[0]); // v1
    vertex(vx[1], vy[1], vz[1]); // v2
    vertex(vx[2], vy[2], vz[2]); // v3
    vertex(vx[3], vy[3], vz[3]); // v4

    vertex(vx[4], vy[4], vz[4]); // v5
    vertex(vx[5], vy[5], vz[5]); // v6
    vertex(vx[6], vy[6], vz[6]); // v7
    vertex(vx[7], vy[7], vz[7]); // v8

    vertex(vx[3], vy[3], vz[3]); // v4
    vertex(vx[2], vy[2], vz[2]); // v3
    vertex(vx[7], vy[7], vz[7]); // v8
    vertex(vx[6], vy[6], vz[6]); // v7

    vertex(vx[5], vy[5], vz[5]); // v6
    vertex(vx[4], vy[4], vz[4]); // v5
    vertex(vx[1], vy[1], vz[1]); // v2
    vertex(vx[0], vy[0], vz[0]); // v1

    vertex(vx[1], vy[1], vz[1]); // v2
    vertex(vx[4], vy[4], vz[4]); // v5
    vertex(vx[7], vy[7], vz[7]); // v8
    vertex(vx[2], vy[2], vz[2]); // v3

    vertex(vx[5], vy[5], vz[5]); // v6
    vertex(vx[1], vy[1], vz[1]); // v1
    vertex(vx[3], vy[3], vz[3]); // v4
    vertex(vx[6], vy[6], vz[6]); // v7
    endShape();

    if (asMoon != 0)
      drawMoon();
  }

  void rotaShape()
  {
    rotateY(frameCount * cubeSpeedY);
    rotateZ(frameCount * cubeSpeedZ);
  }

  void tranShape(float trZ, float trX)
  {
    translate(trX, 0, trZ);
  }

  void display()
  {
    tranShape(this.cubeTranZ, this.cubeTranX);
    rotaShape();
    drawSidome();
  }

  void popDown()
  {
    translate(width / 2, this.downY, this.downZ);
    if (this.downY <= (height * 0.45))
    {
      this.downY = height * 0.45;
      this.downZ -= 40;
      if (this.downZ <= -7000)
        {
          this.fromTable = false;
          this.clr = 0;
          this.clg = 0;
          this.clb = 0;
          this.goIn = true;
        }
    }
    else
      this.downY -= 3;
    drawSidome();
  }

  void out()
  {
    clr = (clr > 0 ? clr - 5 : 0);
    clg = (clg > 0 ? clg - 5 : 0);
    clb = (clb > 0 ? clb - 5 : 0);
    if (clr <= 0 && clg <= 0 && clb <= 0)
    {
      this.goOut = false;
      this.id = null;
    }
  }

  void in()
  {
    clr = (clr < newclr ? clr + 5 : newclr);
    clg = (clg < newclg ? clg + 5 : newclg);
    clb = (clb < newclb ? clb + 5 : newclb);
    if (clr >= newclr && clg >= newclg && clb >= newclb)
      this.goIn = false;
  }
}

