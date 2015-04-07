class WireCube
{
  float cubeSpeedY, cubeSpeedZ;
  float cubeTranX, cubeTranZ;
  float speedRota, axeRota;
  float pos = -7000, x;
  int id;
  float clr, clb, clg;
  boolean goOut, go, isPop;

  WireCube(float speedY, float speedZ, float tranX, float tranZ)
  {
    this.clr = 255;
    this.clg = 255;
    this.clb = 255;
    this.cubeSpeedY = speedY;
    this.cubeSpeedZ = speedZ;
    this.cubeTranX = tranX;
    this.cubeTranZ = tranZ;
    this.x = this.cubeTranX;
    this.speedRota = random(minRota, maxRota);
    this.axeRota = random(-sizeBelt, sizeBelt);
    this.goOut = false;
    this.id = 0;
    this.x = 0;
    this.go = false;
    this.isPop = true;
  }

  void tranShape(float trZ, float trX)
  {
    translate(trX, 0, trZ);
  }

  void rota()
  {
    rotateY(frameCount * this.cubeSpeedY);
    rotateZ(frameCount * this.cubeSpeedZ);
  }

  void display()
  {
    noFill();
    stroke(this.clr, this.clg, this.clb);
    box(sizeCube);
  }

  void popWireCube()
  {
    if (pos <= 1000 && !go)
    {
      tranShape(this.pos, 0);
      rota();
      display();
      this.pos += 55;
    }
    else if (isPop)
    {
      tranShape(this.pos, this.x);
      rota();
      display();
      this.go = true;
      this.pos -= 5;
      this.x = (this.x < this.cubeTranX ? this.x + 5 : this.cubeTranX);
      if (this.pos < this.cubeTranZ)
	this.isPop = false;
    }
  }

  void out()
  {
    clr = (clr > 0 ? clr - 5 : 0);
    clg = (clg > 0 ? clg - 5 : 0);
    clb = (clb > 0 ? clb - 5 : 0);
    if (clr <= 0 && clg <= 0 && clb <= 0)
    {
      this.goOut = false;
      this.id = 0;
      this.x = 0;
      this.go = false;
      this.isPop = true;
      this.id = 0;
      this.pos = -7000;
      this.clr = 255;
      this.clg = 255;
      this.clb = 255;
    }
  }
}
