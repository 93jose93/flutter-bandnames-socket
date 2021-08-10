import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketServices>(context);
   

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Text('Server Status: ${ socketServices.serverStatus }')
          ],
        )
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon( Icons.message),
       onPressed: () {
           //emitir  mensaje 

           socketServices.emit('emitir-mensaje', {
             'nombre': 'Flutter',
             'mensaje': 'Hola desde Flutter'
           });
       },
     ),
   );
  }
}