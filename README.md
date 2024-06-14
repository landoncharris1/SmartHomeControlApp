# Smart Home Control App
This is a Flutter application designed to simplify the management of your home devices. It allows users to control their devices through the app, schedule actions, and track energy consumption with ease through a well designed user-interface.

# Features:

Device Management: Add, remove, and toggle smart home devices.

Scheduling: Create schedules to automate device actions based on time and conditions.

Energy Consumption Tracking: Monitor and track the energy consumption of individual devices and overall energy usage.

Intuitive User Interface: Features a sleek and user-friendly interface, crafted to offer a seamless experience for users of all proficiency levels. Its intuitive design and straightforward navigation ensure effortless control and management of your smart home devices, enhancing the overall user experience.

Bluetooth Control: Connect to Ardunio via Bluetooth to control devices directly

# Technologies:

Flutter: Built using the Flutter framework for cross-platform compatibility.

Dart: Utilizes Dart programming language for app development.

Material Design: Follows Material Design guidelines for a modern and intuitive user interface.

# Getting Started:
Prerequisites:
   1. Install Flutter and Dart extensions in VS Code.
   2. Set up Flutter SDK path in your IDE.
   3. Ensure Flutter and Dart plugins are enabled in Android Studio.

Set Up Android Emulator:
   1. Download and install Android Studio.
   2. Set up an Android Virtual Device (AVD) in Android Studio.

Clone the Repository:
  `1. Clone the SmartHomeControl repository from GitHub to your local machine.
      git clone https://github.com/landoncharris1/SmartHomeControl.git

Run the App:  
   1. Open the cloned project in your preferred Flutter development environment.
   2. Ensure all dependencies are installed using flutter pub get.
   3. Run the app on your configured Android emulator or connected physical device.

# Integrating Arduino via Wi-Fi:
To enable your Smart Home Control app to communicate with Arduino-controlled devices via Wi-Fi, follow these steps:
   1. Install Arduino IDE
      
          • Download and install the Arduino IDE from Arduino's official website.
   3. Set Up Arduino Board (ESP8266)
      
          • Connect your Arduino board (e.g., ESP8266) to your computer via USB.
   5. Upload Arduino Sketch
      
          • Write or download a sketch (program) for Arduino that sets up Wi-Fi connection and controls your devices (e.g., turning relays on/off).
      
          • Use arduino_setup.dart and modify the sketch according to your specific device control needs.
      https://github.com/landoncharris1/SmartHomeControlApp/blob/main/arduino_setup.dart
      
   7. Connect Relay Devices
      
          • Connect devices (like relays controlling lights and fans) to the defined relay pins (relayPin1 and relayPin2).
   9. Use Smart Home Control App:
       
          • Ensure your Arduino and the Flutter app are connected to the same Wi-Fi network.
   11. Control Devices
       
          • Open the Smart Home Control app or use any web browser on the same network to send GET requests to the Arduino's IP address and specified endpoints (/light/on, /light/off, /fan/on, /fan/off) to control the connected devices.

# Bluetooth Setup:
To enable Bluetooth communication between your Smart Home Control app and the devices, follow these steps:

   1. Connect Bluetooth Module
      
          • Connect a Bluetooth module (like HC-05) to your Arduino board.
   3. Upload Blutooth Control Sketch
      
          • Write or download a sketch for Arduino that sets up Bluetooth communication and controls your devices (e.g., turning relays on/off).
      
          • Use bluetooth_setup.dart and modify the sketch according to your specific device control needs. This Arduino sketch focuses on controlling physical devices based on commands received from the Bluetooth module.

      https://github.com/landoncharris1/SmartHomeControlApp/blob/main/bluetooth_setup.dart
      
   5. Create the bluetooth_page.dart file and add the code to initiate connections, send commands, and disconnect from the Arduino
https://github.com/landoncharris1/SmartHomeControlApp/blob/main/bluetooth_page.dart

   7. Create the bluetooth_service.dart fileunder lib/services/ and add the code to handle Bluetooth connections and sending commands to the Arduino device  
https://github.com/landoncharris1/SmartHomeControlApp/blob/main/bluetooth_service.dart

# Explore SmartHomeControl:
Add, remove, and manage smart home devices.
Create schedules to automate device actions based on time and conditions.
Monitor and track the energy consumption of individual devices and overall energy usage.








