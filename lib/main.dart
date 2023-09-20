import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Ringtone Volume Control')),
        body: const Center(
          child: VolumeControlSlider(),
        ),
      ),
    );
  }
}

class VolumeControlSlider extends StatefulWidget {
  const VolumeControlSlider({Key? key}) : super(key: key);

  @override
  VolumeControlSliderState createState() => VolumeControlSliderState();
}

class VolumeControlSliderState extends State<VolumeControlSlider> {
  static const platform = MethodChannel('beny.native/volume'); // Channel name
  double _currentVolume = 0.5; // Initial volume level

  /// Get the current volume level from the native side
  void setRingtoneVolume(double volume) async {
    try {
      await platform.invokeMethod(
          'setRingtoneVolume', {'volume': (volume * 100).toInt()});
    } on PlatformException catch (e) {
      log("Error setting ringtone volume: $e");
    }
  }

  /// Show a snackbar to indicate the volume level has been changed
  void showVolumeSnackBar() {
    SnackBar snackBar = SnackBar(
      content: Text(
          'Ringtone volume set to ${(_currentVolume * 100).toStringAsFixed(0)}%'),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Slider to control the volume level
        Slider(
          value: _currentVolume,
          onChanged: (newValue) {
            /// Update the volume level and set the volume on the native side
            setState(() {
              _currentVolume = newValue;
              setRingtoneVolume(newValue);
            });
          },
          onChangeEnd: (newValue) {
            showVolumeSnackBar(); // Show a snackbar when the volume is changed
          },
        ),
        Text('Ringtone Volume: ${(_currentVolume * 100).toStringAsFixed(0)}%'),
      ],
    );
  }
}
