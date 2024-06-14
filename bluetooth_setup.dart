#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3); // RX, TX pins for Bluetooth module

void setup() {
  Serial.begin(9600); // Serial monitor for debugging
  BTSerial.begin(9600); // Bluetooth module baud rate
  
  pinMode(LED_BUILTIN, OUTPUT);
  
  Serial.println("Bluetooth Control Ready");
}

void loop() {
  if (BTSerial.available()) {
    char command = BTSerial.read();
    Serial.print("Received command: ");
    Serial.println(command);
    
    if (command == '1') {
      digitalWrite(LED_BUILTIN, HIGH); // Turn on LED
      BTSerial.println("LED is ON");
    } else if (command == '0') {
      digitalWrite(LED_BUILTIN, LOW); // Turn off LED
      BTSerial.println("LED is OFF");
    } else {
      BTSerial.println("Unknown command");
    }
  }
}
