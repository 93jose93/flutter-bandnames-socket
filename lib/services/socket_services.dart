import 'package:flutter/material.dart';
 
import 'package:socket_io_client/socket_io_client.dart' as IO;
 
enum ServerStatus { Online, Offline, Connecting }
 
class SocketServices with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
 
  ServerStatus get serverStatus => this._serverStatus;
 
  //esto es para usar en cualquier otra pantalla, emite y escucha
  IO.Socket get socket => this._socket;

  //este es para solo enviar infromacion y no escuchar
  Function get emit => this._socket.emit;
 
  SocketServices() {
    this._initConfig();
  }
 
  void _initConfig() {
    String urlSocket = 'http://192.168.1.102:3000'; //tu ipv4 con iPconfig (windows)
 
    this._socket = IO.io(
        urlSocket,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
 
    // Estado Conectado
    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      print('Conectado por Socket');
      notifyListeners();
    });
 
    // Estado Desconectado
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      print('Desconectado del Socket Server');
      notifyListeners();
    });

    /*
    aqui se realizo un testeo de si recibe informacion desde el servidor, a traes del vagador web consola, enviando un objeto
 

      // Estado Mensaje
    this._socket.on('nuevo-mensaje',( payload ) {
      //imprime el objeto que se envia desde el nevegador
      //print('nuevo-mensaje: $payload');

      print('nuevo-mensaje');
      print('nombre:' + payload['nombre']);
      print('mensaje:' + payload['mensaje']);

      //validar cuando una propedad no se encuentre definido y no salga error
      print( payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');

     
    });

    */
  }
}