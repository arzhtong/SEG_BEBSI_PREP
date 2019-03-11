import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'information_parser.screen.dart';
import './category.screen.dart';

class AppointmentPrep extends StatefulWidget {
  final String _testID;

  AppointmentPrep(this._testID);

  @override
  _AppointmentPrepState createState() => _AppointmentPrepState();
}

class _AppointmentPrepState extends State<AppointmentPrep> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('tests').document(widget._testID).collection('prepCards').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            padding: EdgeInsets.only(top: 10.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>_makeData(context,snapshot.data.documents[index])
          );
        }
    );
  }

  Widget _makeData(BuildContext context, DocumentSnapshot document) {
    return CategoryCard(document['contents'].toString(),
        document['title'].toString(), document['type'].toString(), widget._testID);
  }
}

class CategoryCard extends StatelessWidget {
  final String contents;
  final String title;
  final String type;
  final String _testID;

  CategoryCard(this.contents, this.title, this.type, this._testID);

  Widget _getCategoryIcon(String type) {
    switch (type) {
      case "informations":
        return CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.info,
            color: Colors.white,
          ),
        );
      case "categoryList":
        return CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.list,
            color: Colors.white,
          ),
        );
      case "recipieView":
        return CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.fastfood,
            color: Colors.white,
          ),
        );
      default:
        return CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(
            Icons.info,
            color: Colors.white,
          ),
        );
    }
  }

  Future _navigate(dynamic context) {
    //TODO: add links to the relevant pages

    switch (type) {
      case "informations":
        return Navigator.push(context, MaterialPageRoute(builder: (context) => InformationParser(_testID, contents)));
      case "categoryList":
        return null;
      case "recipieView":
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
        child: Card(
          elevation: 3.0,
          child: InkWell(
              onTap: () {
                _navigate(context);
              },
              child: ListTile(
                leading: _getCategoryIcon(type),
                title: Text(title),
              )
          ),
        )
    );
  }
}