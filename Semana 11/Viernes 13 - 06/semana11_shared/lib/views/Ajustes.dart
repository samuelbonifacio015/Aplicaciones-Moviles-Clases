import 'package:flutter/material.dart';
import 'package:semana11_shared/pref/Preferencias.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  State<Ajustes> createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {

  Preferencias pref=Preferencias();

  @override
  void initState() {
    pref.init().then((value){
      setState(() {
        pref=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController passController=TextEditingController(text: pref.pass);

    return Scaffold(

      appBar: AppBar(
        title: Text('Preferences - Flutter'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),


      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.wifi),
                ),
                Expanded(child: Text('Activar Wifi')),
                Switch(
                    value: pref.wifi,
                    onChanged: (value){
                      setState(() {
                        pref.wifi=value;
                        pref.guardarRed();
                      });
                    })
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.lock),
                ),

                Expanded(
                    child:Text('Ingrese Clave Wifi')),

                Container(
                  width: 120,
                  child: TextField(
                    controller: passController,
                    onChanged: (value){
                      pref.pass=value;
                      pref.guardarPass();
                    },
                  ),
                )
              ],
            )

          ],
        ),
      ),




    );
  }
}
