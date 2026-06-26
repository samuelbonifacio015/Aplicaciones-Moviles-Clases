import 'package:flutter/material.dart';

import 'package:drift/native.dart';
import '../database/database.dart';
import 'NewUser.dart';


class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {

  final database=AppDatabase(NativeDatabase.memory());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('List Users'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<User>>(
          future: database.getListUsers(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<User>? userList=snapshot.data;
              return ListView.builder(
                  itemCount: userList!.length,
                  itemBuilder: (context,index){
                    User userData=userList[index];
                    return ListTile(
                      title: Text(userData.nombre),
                      subtitle: Text(userData.correo),
                    );
                  });
            }else if(snapshot.hasError){
              return Center(
                child: Text('Error de carga'),
              );
            }else{
              return Center(
                child: Text('Lista Vacia'),
              );
            }
          }),

      floatingActionButton: FloatingActionButton(
          onPressed: (){
            _nuewUser();
          },
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        child: Icon(Icons.add),
          ),


    );
  }

  void _nuewUser() async{
    var res=await Navigator.push(context,
    MaterialPageRoute(builder: (context)=>Newuser()));
    if(res!=null && res==true){
      setState(() {

      });
    }
  }
}
