import 'package:flutter/material.dart';

class AppointmentDetails {
  final String _name;
  final String _location;
  final DateTime _dateTime;
  final String _testId;
  final String _doctorName;
  final String _testName;
  final Color _color;

  AppointmentDetails(this._name, this._location, this._dateTime, this._testId,
      this._doctorName, this._testName, this._color);
  
  String get name{
    return _name;
  }

  String get location{
    return _location;
  }

  DateTime get dateTime{
    return _dateTime;
  }

  String get testId{
    return _testId;
  }

  String get doctorName{
    return _doctorName;
  }

  String get testName{
    return _testName;
  }

  Color get color{
    return _color;
  }
}
