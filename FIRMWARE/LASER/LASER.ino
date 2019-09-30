const int BL = 10;
const int  GL = 9;
const int  XP = 5;
const int  YP = 6;

void setPwmFrequency(int pin, int divisor) {
  byte mode;
  if(pin == 5 || pin == 6 || pin == 9 || pin == 10) {
    switch(divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 64: mode = 0x03; break;
      case 256: mode = 0x04; break;
      case 1024: mode = 0x05; break;
      default: return;
    }
    if(pin == 5 || pin == 6) {
      TCCR0B = TCCR0B & 0b11111000 | mode;
    } else {
      TCCR1B = TCCR1B & 0b11111000 | mode;
    }
  } else if(pin == 3 || pin == 11) {
    switch(divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 32: mode = 0x03; break;
      case 64: mode = 0x04; break;
      case 128: mode = 0x05; break;
      case 256: mode = 0x06; break;
      case 1024: mode = 0x07; break;
      default: return;
    }
    TCCR2B = TCCR2B & 0b11111000 | mode;
  }
}

void setup() {
  pinMode(BL, OUTPUT);
  pinMode(GL, OUTPUT);
  pinMode(XP, OUTPUT);
  pinMode(YP, OUTPUT);
  analogWrite(BL, 0);
  analogWrite(GL, 100);
  setPwmFrequency(BL, 1);
  setPwmFrequency(GL, 1);
  setPwmFrequency(XP, 1);
  setPwmFrequency(YP, 1);
  //digitalWrite(7, HIGH);
  //digitalWrite(6, HIGH);
}

int i = 0;

int[][] vectors;

int x, y;

void lineTo(X, Y){
  
  x = 0;
  y = 0;
}

void loop() {
  analogWrite(BL, 0);
  analogWrite(GL, 255);
  for(i = 0; i < 255; i+= 1){
    analogWrite(XP, i);
    //delay(1);
  }
  analogWrite(BL, 255);
  analogWrite(GL, 0);  
  analogWrite(XP, 0);
  /*
  //analogWrite(, i);
  i+=10;
  digitalWrite(A2, LOW);
  digitalWrite(A3, HIGH);
  delay(300);
  analogWrite(A4, i);
  analogWrite(A5, i);
  i+=10;
  //digitalWrite(A5, LOW);
  digitalWrite(A3, LOW);
  digitalWrite(A2, HIGH);*/
}
