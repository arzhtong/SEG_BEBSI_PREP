import 'package:flutter/material.dart';

class DailyCheckups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DailyCheckupsState();
  }
}

class DailyCheckupsState extends State<DailyCheckups> {
  int _currentStep = 0;

  List<Step> _mySteps(){
    List<Step> _steps = [
      Step(
        title: Text('3 Days to appointment'),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Text("Have you eaten any not allowed foods?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('2 Days to appointment'),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Text("Have you eaten wheat in the last 24 hours?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('1 Day to appointment'),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Usual breakfast before 9:00am"),
                  Divider(),
                  Text("Special diet from 9:00am"),
                  Divider(),
                  Text("Fasting starting in the evening and lasting 15 hours (until the appointment time)"),
                ],
              ),
              leading: Icon(Icons.info),
            ),
            Divider(),
            ListTile(
              title: Text("Have you drank 10 liters of water today?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Day of the apointment'),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Text("Fast until the time of the appointment"),
              leading: Icon(Icons.info),
            ),
            Divider(),
            ListTile(
              title: Text("Have you NOT eaten anything in 15 hours?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _steps;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stepper(
        steps: _mySteps(),
        currentStep: this._currentStep,
        onStepTapped: (step){
          setState((){
            this._currentStep = step;
          });
        },
      ),
    );
  }
}