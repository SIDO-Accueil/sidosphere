void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println(map(analogRead(A0), 0, 25, 0, 1000));
  delay(500);
}
