int pin = -1;
String mode = "";
int value = -1;

//Pin 4 ----> Farm de cenoura pullup
//Pin 7 ----> Farm de abóbora
//Pin 8 ----> Está de noite
//Pin 12 ---> Está de dia
//Pin 6 ----> AND teste

void setup() {
  Serial.begin(38400);
  Serial.setTimeout(5);
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}

void loop() {
  char data[11];
  byte size = Serial.readBytes(data, 10);
  data[size] = NULL;
  if(data[0] != NULL)
  {
    char* entries = strtok(data, ";");
    int index = 0;
    while(entries != NULL)
    {
      if(index == 0) { pin = getPin(entries); }
      if(index == 1) { mode = entries; }
      if(index == 2) { value = atoi(entries); }
      entries = strtok(NULL, ";");
      index += 1;
    }
  }

  if(pin != -1 && mode == "ir" && value != -1)
  {
    handleInterrupt();
    pin = -1;
    mode = "";
    value = -1;
  }
  else if(pin != -1 && mode != "" && value != -1)
  {
    writeToPin();
    pin = -1;
    mode = "";
    value = -1;
  }
  else if(pin != -1 && mode != "" && value == -1)
  {
    readFromPin();
    pin = -1;
    mode = "";
  }


}

//You need to edit this if your board has more, less or different interrupt pins than the Arduino UNO. Make sure that those pins can use the CHANGE mode.
void handleInterrupt(){
  if(value == 1)
  {
    attachInterrupt(digitalPinToInterrupt(pin), pin == 2 ? pin2 : pin3, CHANGE); //You need to add the additional ISRs here
  }
  else
  {
    detachInterrupt(digitalPinToInterrupt(pin));
  }
}

void writeToPin(){
  pinMode(pin, OUTPUT);
  if(mode == "dw")
  {
    digitalWrite(pin, value);
  }
  else
  {
    analogWrite(pin, value);
  }
}

void readFromPin(){
  int val = -1;
  if(mode == "ar")
  {
    pinMode(pin, INPUT);
    val = analogRead(pin);
    val = map(val, 0, 1023, 0, 15);
  }
  else if(mode == "drp")
  {
    pinMode(pin, INPUT_PULLUP);
    val = digitalRead(pin);
  }
  else
  {
    pinMode(pin, INPUT);
    val = digitalRead(pin);
  }
  String out = String(pin) + String(";") + mode + String(";") + String(val);
  Serial.println(out);
}

void pin2(){
  String out = String("2;ir;") + String(digitalRead(2));
  Serial.println(out);
}

//You need to duplicate this method for additional interrupt pins
void pin3(){
  String out = String("3;ir;") + String(digitalRead(3));
  Serial.println(out);
}

//You need to change this if your board has more or less analog inputs than the Arduino UNO.
int getPin(char* p){
  if(p == "A0"){ return A0; }
  if(p == "A1"){ return A1; }
  if(p == "A2"){ return A2; }
  if(p == "A3"){ return A3; }
  if(p == "A4"){ return A4; }
  if(p == "A5"){ return A5; }
  return atoi(p);
}