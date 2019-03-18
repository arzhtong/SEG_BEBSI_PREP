import 'package:flutter/material.dart';

class MakeHelpIcon extends StatelessWidget{
  String info;
  
  MakeHelpIcon(this.info);
  Widget build(BuildContext context){
    return IconButton(icon: new Icon(Icons.help,color: Colors.indigo[50]),onPressed: () {makeAlert(context,info);
   } 
 );    
 }
}
    Widget makeAlert(BuildContext context,String text){
      var alertdialog= AlertDialog(title: Text("What is this page for?",style: TextStyle(fontSize: 40.0)),content: Text(text,style:TextStyle(fontSize: 30.0)),
      );

      showDialog(context: context,builder: (BuildContext context){
       return alertdialog;
      });
      
    }


