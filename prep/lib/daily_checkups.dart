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
        title: Text('2 Days until test'),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Text("Have you eater wheat in the last 24 hours?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('The day before the test '),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Text("Have you drank 10 liters of water today?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('The day of the test'),
        content: Column(
          children: <Widget>[
            ListTile(
              title: Text("Have you NOT eaten anything in 15 hours?"),
              leading: Icon(Icons.done_outline),
            ),
            TextField(),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
    ];
    return _steps;
  }

  @override
  Widget build(BuildContext context) {
    return
      ListView(
        children: <Widget>[
          Stepper(
            steps: _mySteps(),
            currentStep: this._currentStep,
            onStepTapped: (step){
              setState((){
                this._currentStep = step;
              });
            },
          )
        ],
    );
  }
}