import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:your_app/services/bluetooth_service.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final BluetoothService _bluetoothService = BluetoothService();
  final TextEditingController _deviceAddressController = TextEditingController();
  bool _connecting = false;

  @override
  void dispose() {
    _deviceAddressController.dispose();
    super.dispose();
  }

  Future<void> _connectToBluetooth() async {
    setState(() {
      _connecting = true;
    });

    String deviceAddress = _deviceAddressController.text.trim();
    await _bluetoothService.connectToBluetooth(deviceAddress);

    setState(() {
      _connecting = false;
    });
  }

  void _sendCommand(String command) {
    _bluetoothService.sendCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _deviceAddressController,
                decoration: InputDecoration(
                  labelText: 'Device Address',
                  hintText: '00:00:00:00:00:00', // Replace with your device address format
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _connecting ? null : _connectToBluetooth,
              child: _connecting ? CircularProgressIndicator() : Text('Connect'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendCommand('1'); // Command to turn LED ON
              },
              child: Text('Turn LED ON'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendCommand('0'); // Command to turn LED OFF
              },
              child: Text('Turn LED OFF'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bluetoothService.isConnected ? _bluetoothService.disconnect : null,
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
