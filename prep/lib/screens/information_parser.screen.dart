import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prep/utils/query.dart';

class InformationParser extends StatefulWidget {
  final String _documentName;

  InformationParser(this._documentName);

  @override
  State<StatefulWidget> createState() => _InformationParserState();
}

class _InformationParserState extends State<InformationParser> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return Container(
        child: SingleChildScrollView(
          child: Html(
            data: document['content'],
            padding: EdgeInsets.all(20.0),
            useRichText: true,  //turn this off to get the alternative parser
            onLinkTap: (url){
              //TODO: decide how to handle hyperlinks in the HTML
              print("Handling links");
            },
            customRender: null,
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Information"),
      ),
      body: StreamBuilder(
        stream: Queries.informationSnapshots(widget._documentName),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
          return _buildListItem(context, snapshot.data);
        }
      ),
    );
  }
}