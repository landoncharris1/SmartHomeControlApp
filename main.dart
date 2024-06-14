import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Device> devices = [];
  List<Schedule> schedules = [];

  void _addDevice(Device device) {
    setState(() {
      devices.add(device);
    });
  }

  void _removeDevice(int index) {
    setState(() {
      devices.removeAt(index);
    });
  }

  void _showAddDeviceDialog() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _consumptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                maxLength: 20, // Set maximum length for device name
                decoration: InputDecoration(labelText: 'Enter device name'),
              ),
              TextField(
                controller: _consumptionController,
                decoration: InputDecoration(labelText: 'Enter energy consumption (kWh)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String name = _nameController.text.trim();
                double consumption = double.tryParse(_consumptionController.text) ?? 0.0;

                if (name.isEmpty || name.length > 20) {
                  _showErrorDialog('Invalid device name. Name must not be empty and should be less than 20 characters.');
                  return;
                }

                if (consumption <= 0) {
                  _showErrorDialog('Invalid energy consumption. Please enter a valid positive number.');
                  return;
                }

                _addDevice(Device(name: name, consumption: consumption));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleDeviceStatus(Device device, bool status) {
    setState(() {
      if (device.status != status) {
        if (device.status) {
          if (device.lastStartTime != null) {
            final Duration onDuration = DateTime.now().difference(device.lastStartTime!);
            device.usageTime += onDuration.inSeconds; // Update usage time in seconds
            device.energyConsumed += device.consumption * (onDuration.inSeconds / 3600); // Update energy consumption
            device.lastStartTime = null;
          }
        }
        device.status = status;
        if (status) {
          device.lastStartTime = DateTime.now();
        }
      }
    });
  }

  void _addSchedule(Schedule schedule) {
    setState(() {
      schedules.add(schedule);
    });
  }

void _editSchedule(int index, Schedule updatedSchedule) {
  setState(() {
    schedules[index] = updatedSchedule;
  });
}

void _deleteSchedule(int index) {
  setState(() {
    schedules.removeAt(index);
  });
}

double _calculateEnergyConsumption() {
  double totalConsumption = 0;
  for (var device in devices) {
    double consumption = device.energyConsumed;
    totalConsumption += consumption;
  }
  return totalConsumption;
}


  void _showAddScheduleDialog({Schedule? schedule, int? index}) {
    final TextEditingController _deviceController = TextEditingController(text: schedule?.device ?? '');
    final TextEditingController _timeController = TextEditingController(
      text: schedule != null ? _formatTimeOfDay(schedule.time) : '',
    );
    final TextEditingController _daysController = TextEditingController(
      text: schedule != null ? schedule.daysOfWeek.join(',') : '',
    );
    final TextEditingController _conditionController = TextEditingController(text: schedule?.condition ?? '');
    bool _action = schedule?.action ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(schedule == null ? 'Add New Schedule' : 'Edit Schedule'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _deviceController,
                      decoration: InputDecoration(labelText: 'Enter device name'),
                    ),
                    TextField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Enter time (HH:MM)'),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: _daysController,
                      decoration: InputDecoration(labelText: 'Enter days of the week (comma-separated)'),
                    ),
                    TextField(
                      controller: _conditionController,
                      decoration: InputDecoration(labelText: 'Enter condition (e.g., dark)'),
                    ),
                    Row(
                      children: [
                        Text('Action: '),
                        Switch(
                          value: _action,
                          onChanged: (value) {
                            setState(() {
                              _action = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(schedule == null ? 'Add' : 'Update'),
                  onPressed: () {
                    String device = _deviceController.text;
                    if (!devices.any((d) => d.name == device)) {
                      _showErrorDialog('Device named "$device" not found.');
                      return;
                    }
                    List<String> timeParts = _timeController.text.split(':');
                    if (timeParts.length != 2 || int.tryParse(timeParts[0]) == null || int.tryParse(timeParts[1]) == null) {
                      _showErrorDialog('Invalid time format. Please enter in HH:MM format.');
                      return;
                    }
                    TimeOfDay time = TimeOfDay(
                      hour: int.parse(timeParts[0]),
                      minute: int.parse(timeParts[1]),
                    );
                    List<int> daysOfWeek = _daysController.text.split(',').map((e) => int.tryParse(e.trim()) ?? -1).toList();
                    if (daysOfWeek.contains(-1) || daysOfWeek.any((day) => day < 1 || day > 7)) {
                      _showErrorDialog('Invalid days of the week. Please enter numbers between 1 and 7.');
                      return;
                    }
                    String condition = _conditionController.text;
                    if (device.isEmpty || condition.isEmpty) {
                      _showErrorDialog('Device and condition fields cannot be empty.');
                      return;
                    }
                    Schedule newSchedule = Schedule(
                      device: device,
                      time: time,
                      action: _action,
                      daysOfWeek: daysOfWeek,
                      condition: condition,
                    );
                    if (schedule == null) {
                      _addSchedule(newSchedule);
                    } else {
                      _editSchedule(index!, newSchedule);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getDaysOfWeek(List<int> days) {
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.map((day) => weekdays[day - 1]).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Change length to 2 after removing the Device Groups tab
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Smart Home Control"),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Devices'),
              Tab(text: 'Energy Insights'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Devices Tab
            Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  device.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16), // Adjust the font size as needed
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _toggleDeviceStatus(device, true);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 8), // Adjust the button padding
                                  minimumSize: Size(60, 36), // Set a minimum button size
                                  backgroundColor: device.status ? Colors.green : Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'On',
                                  style: TextStyle(fontSize: 12), // Adjust the button text size
                                ),
                              ),
                              SizedBox(width: 4), // Add spacing between buttons
                              ElevatedButton(
                                onPressed: () {
                                  _toggleDeviceStatus(device, false);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 8), // Adjust the button padding
                                  minimumSize: Size(60, 36), // Set a minimum button size
                                  backgroundColor: device.status ? Colors.grey : Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Off',
                                  style: TextStyle(fontSize: 12), // Adjust the button text size
                                ),
                              ),
                              SizedBox(width: 4), // Add spacing between buttons
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _removeDevice(index);
                                },
                                padding: EdgeInsets.all(8), // Adjust the padding of the icon button
                              ),
                            ],
                          ),
                          trailing: Icon(
                            device.status ? Icons.power_settings_new : Icons.power_off,
                            color: device.status ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _showAddDeviceDialog,
                    child: Text('Add Device'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _showAddScheduleDialog,
                    child: Text('Add Schedule'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return ListTile(
                          title: Text(schedule.device),
                          subtitle: Text(
                              '${schedule.time.format(context).replaceAll('AM', '').replaceAll('PM', '')} - ${_getDaysOfWeek(schedule.daysOfWeek)} - ${schedule.action ? 'Turn On' : 'Turn Off'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showAddScheduleDialog(schedule: schedule, index: index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteSchedule(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Energy Insights Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Energy Consumption: ${_calculateEnergyConsumption().toStringAsFixed(2)} kWh',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        final int minutes = device.usageTime ~/ 60;
                        final int seconds = device.usageTime % 60;
                        return ListTile(
                          title: Text(device.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Usage Time: ${minutes}m ${seconds}s'),
                              Text('Energy Consumed: ${device.energyConsumed.toStringAsFixed(2)} kWh'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Device {
  String name;
  double consumption;
  bool status;
  int usageTime;
  double energyConsumed;
  DateTime? lastStartTime;

  Device({
    required this.name,
    required this.consumption,
    this.status = false,
    this.usageTime = 0,
    this.energyConsumed = 0.0,
    this.lastStartTime,
  });
}

class Schedule {
  String device;
  TimeOfDay time;
  bool action;
  List<int> daysOfWeek;
  String condition;

  Schedule({
    required this.device,
    required this.time,
    required this.action,
    required this.daysOfWeek,
    required this.condition,
  });
}
