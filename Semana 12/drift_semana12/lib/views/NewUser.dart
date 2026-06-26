import 'package:flutter/material.dart';
import 'package:drift/native.dart';
import '../database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' as dr;


class Newuser extends StatefulWidget {
  const Newuser({super.key});

  @override
  State<Newuser> createState() => _NewuserState();
}

class _NewuserState extends State<Newuser> {

  late TextEditingController txtNombre;
  late TextEditingController txtCorreo;


  @override
  void initState() {
    txtCorreo=TextEditingController();
    txtNombre=TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final database=AppDatabase(NativeDatabase.memory());

    return Scaffold(
      appBar: AppBar(
        title: Text('List Users'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: Container(
        child: Column(
          children: [

            TextFormField(
              controller: txtNombre,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                hintText: 'Ingrese Nombre:'
              ),
            ),

            SizedBox(
              height: 30,
            ),

            TextFormField(
              controller: txtCorreo,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  hintText: 'Ingrese Correo:'
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
                onPressed: (){
                  database.insertUser(UsersCompanion(
                    nombre: dr.Value(txtNombre.text),
                    correo: dr.Value(txtCorreo.text)
                  )).then((value){
                    Navigator.pop(context,true);
                  });
                },
                child: Text('Grabar Usuario'))


          ],
        ),
      ),


    );
  }
}
