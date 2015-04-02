int rot = 0;
int i = -1;
final int nb_cube = 500;
PShape[] cubelist = new PShape[nb_cube];
float[] k = new float[nb_cube];
PShape cube;

void setup() {
  size(1920, 1080, P3D);
  noFill();
  stroke(255);
  i = -1;
  while (++i < nb_cube) {
    cubelist[i] = createShape(BOX, 20);
    k[i] = random(1, 360);
  }
}

void draw() { 
frameRate(60);
  i = -1;
  background(0, 0, 0);
  translate(width / 2, height / 2);
  while (++i < nb_cube) {
    pushMatrix();
    rotate((millis() * 0.0005 * HALF_PI), sin((k[i] * 100) / 1000) * 360, 90, 0);
    translate(0, 0, 350 + k[i]);
    cubelist[i].rotateX((millis() * 0.0001f) / (millis() * 0.042));
    cubelist[i].rotateY((millis() * 0.0001f) / (millis() * 0.042));
    shape(cubelist[i]);
    popMatrix();
  }
  rot++;
  if (rot >= 360)
    rot = 0;
}

