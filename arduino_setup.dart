#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

// Replace with your network credentials
const char* ssid = "your_SSID";
const char* password = "your_PASSWORD";

// Create an instance of the server
ESP8266WebServer server(80);

// Define relay pins
const int relayPin1 = 7;
const int relayPin2 = 8;

void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Initialize relay pins as outputs
  pinMode(relayPin1, OUTPUT);
  pinMode(relayPin2, OUTPUT);

  // Start with relays off
  digitalWrite(relayPin1, HIGH);
  digitalWrite(relayPin2, HIGH);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Define routes
  server.on("/", handleRoot);
  server.on("/light/on", handleLightOn);
  server.on("/light/off", handleLightOff);
  server.on("/fan/on", handleFanOn);
  server.on("/fan/off", handleFanOff);

  // Start server
  server.begin();
  Serial.println("Server started");

  // Instructions for users
  Serial.println("");
  Serial.println("Arduino is now connected to your Wi-Fi network.");
  Serial.println("Use any web browser on the same network to control the devices.");
  Serial.println("Access the following endpoints:");
  Serial.println("- /light/on   : Turn the light on");
  Serial.println("- /light/off  : Turn the light off");
  Serial.println("- /fan/on     : Turn the fan on");
  Serial.println("- /fan/off    : Turn the fan off");
  Serial.println("");
}

void loop() {
  // Handle client requests
  server.handleClient();
}

void handleRoot() {
  String html = "<html><body>"
                "<h1>Smart Home Control</h1>"
                "<button onclick=\"location.href='/light/on'\">Turn Light On</button>"
                "<button onclick=\"location.href='/light/off'\">Turn Light Off</button><br><br>"
                "<button onclick=\"location.href='/fan/on'\">Turn Fan On</button>"
                "<button onclick=\"location.href='/fan/off'\">Turn Fan Off</button>"
                "</body></html>";
  server.send(200, "text/html", html);
}

void handleLightOn() {
  digitalWrite(relayPin1, LOW);
  server.send(200, "text/plain", "Light is ON");
}

void handleLightOff() {
  digitalWrite(relayPin1, HIGH);
  server.send(200, "text/plain", "Light is OFF");
}

void handleFanOn() {
  digitalWrite(relayPin2, LOW);
  server.send(200, "text/plain", "Fan is ON");
}

void handleFanOff() {
  digitalWrite(relayPin2, HIGH);
  server.send(200, "text/plain", "Fan is OFF");
}
