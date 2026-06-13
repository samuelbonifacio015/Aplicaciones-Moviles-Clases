import 'package:flutter/material.dart';
import 'package:semana11_shared/views/Ajustes.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Preferences - Flutter'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Preferences in Flutter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context){
              return Ajustes();
            }));
          }),
    );
  }
}
