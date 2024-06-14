import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  BluetoothConnection? connection;
  bool get isConnected => connection != null && connection!.isConnected;

  Future<void> connectToBluetooth(String deviceAddress) async {
    try {
      connection = await BluetoothConnection.toAddress(deviceAddress);
      print('Connected to device');
      connection!.input!.listen((Uint8List data) {
        print('Received: ${String.fromCharCodes(data)}');
        // Handle received data here if needed
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void sendCommand(String command) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(utf8.encode(command + "\n"));
      connection!.output.allSent.then((_) {
        print('Sent: $command');
      });
    } else {
      print('Not connected to a device.');
    }
  }

  void disconnect() {
    connection?.dispose();
    connection = null;
  }
}
