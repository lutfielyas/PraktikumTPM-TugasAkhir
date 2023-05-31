// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';

class TimePage extends StatefulWidget {
  const TimePage({Key? key}) : super(key: key);

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  static const String _input = 'WIB';
  late String _output = 'WIB';
  DateTime _result = DateTime.now();
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  late DateTime _convertedResult = DateTime.now();

  @override
  void initState() {
    super.initState();
    _output = 'WIB';
    _result = DateTime.now();
    _convertedResult = _convertTime(_output);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _result = DateTime.now();
        _convertedResult = _convertTime(_output);
      });
    });
  }

  DateTime _convertTime(String output) {
    switch (output) {
      case 'WIB':
        return DateTime.now();
      case 'WITA':
        return DateTime.now().add(const Duration(hours: 1));
      case 'WIT':
        return DateTime.now().add(const Duration(hours: 2));
      case 'GMT London':
        return DateTime.now().subtract(const Duration(hours: 6));
      default:
        return DateTime.now();
    }
  }

  void _onOutputChanged(String? value) {
    setState(() {
      _output = value ?? 'WIB';
      _convertedResult = _convertTime(_output);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Icon(
            Icons.access_time,
            size: 20,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Text(
            'Default Time: $_input',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildOutput() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      value: _output,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Output',
        labelStyle: TextStyle(color: Colors.black),
      ),
      onChanged: _onOutputChanged,
      items: const [
        DropdownMenuItem(
          value: 'WIB',
          child: Text(
            'WIB',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'WITA',
          child: Text(
            'WITA',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'WIT',
          child: Text(
            'WIT',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'GMT London',
          child: Text(
            'GMT London',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            size: 40,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Text(
            '${_result.hour.toString().padLeft(2, '0')}:${_result.minute.toString().padLeft(2, '0')}:${_result.second.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 40, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildConvertedResult() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      initialData: _convertedResult,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.access_time,
                    size: 30,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Converted Time',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${_convertedResult.hour.toString().padLeft(2, '0')}:${_convertedResult.minute.toString().padLeft(2, '0')}:${_convertedResult.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Time Converter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInput(),
            const SizedBox(height: 20),
            _buildOutput(),
            const SizedBox(height: 20),
            _buildResult(),
            const SizedBox(height: 20),
            _buildConvertedResult(),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth,
              height: 1,
              child: Container(color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Time Converter',
    home: TimePage(),
  ));
}
