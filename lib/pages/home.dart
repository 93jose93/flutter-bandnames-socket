import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //nuevo listado

  List<Band> bands = [

    /*
    //este era la lista que se hacia antes para mostrar

    Band(id: '1', name: 'Metallica', votes: 3),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'AC/DC', votes: 2),
    Band(id: '4', name: 'Rammstein', votes: 5),

    */
  ];

  @override
  void initState() {
    

    final socketServices = Provider.of<SocketServices>(context, listen: false);
    
    //aqui escuchamos el enevto que se creo en el servidor
    socketServices.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }


  _handleActiveBands(dynamic payload) {
     //trae la lista del servidor
       //print(payload)

      this.bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();
      
      setState(() {}); 
  }

  @override
  void dispose() {
    //este se hace para evitar estar escuchando cuando ya no se necesita
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    socketServices.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget> [
          Container(
            margin: EdgeInsets.only( right:10 ),
            child: 
              //si esta conectado
            ( socketServices.serverStatus ==  ServerStatus.Online )
             //mostramos este icono 
             ? Icon(Icons.check_circle, color: Colors.blue[300],)
             //casi coontrario mostrara el otro icono
             :  Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ]
      ),
      //encima del buil contrl+. podemos cotruirlo rapido
      body: Column(
        children: <Widget>[
             //mostrara la grafica
             _showGraph(),

             Expanded(
               //el ListView detro de un container necesita Expanded
               //muestra una lista de bandas
               child: ListView.builder(
                 itemCount: bands.length,
                 itemBuilder: ( context, i) => _banTile(bands[i]),     
               ),
             )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add),
        elevation: 1,
        //voton elevado, se a creado un metodo
        //solo referencia
        onPressed: addNewBand,
      ),
   );
  }

  //metodo
  Widget _banTile(Band band) {

     final socketServices = Provider.of<SocketServices>(context, listen: false);


    //este Dismissible es para mover de lado y borrar algo de la app
    return Dismissible(
      key: Key(band.id),
      //que solo s emueva a un solo lado
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) {
         //print('direction $direction');
         //print('id: ${ band.id }');

        //ahora agregaremos el nombre de la banda
        socketServices.emit('delete-band', {
             'id' : band.id
        });

      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.purple,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),),
        )
      ),
      child: ListTile(
              leading: CircleAvatar(
                //substring muestra las primeras dos letras
                child: Text( band.name.substring(0, 2)),
                backgroundColor: Colors.blue[100],
              ),
              title: Text( band.name ),
              trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20),),
              onTap: () {
                  socketServices.socket.emit('vote-band', {
                      'id' : band.id
                  });

              //necesitamos el id, ya que es lo que icrementaremos en 1
              // print(band.id);
              },
            ),
    );
  }

  //metodo 
  addNewBand(){
      final textController = new TextEditingController();

      if( !Platform.isAndroid ){
          
           //mostrar un dialogo
          return showDialog(
          context: context,
          //cuando se hace un builder es que se va regresar algo, entonces por eso se usa return
          builder: ( _ ) => AlertDialog(
              title: Text('New band name:'),
              //este recibe lo que se escribe en la caja
              content: TextField(
                controller: textController,
              ),
              actions: [
                  MaterialButton(
                    child: Text('add'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => addBandToList(textController.text)
                  )
              ],
          )
          
          );

      }

      showCupertinoDialog(
        context: context, 
        builder: ( _ ) => CupertinoAlertDialog(
            title: Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
               CupertinoDialogAction(
                 isDefaultAction: true,
                 child: Text('Add'),
                 onPressed: () => addBandToList(textController.text)
               ),
                CupertinoDialogAction(
                 isDestructiveAction: true,
                 child: Text('Dismiss'),
                 onPressed: () => Navigator.pop(context)
               )
            ],
        )   
      );


     
  }

  //nuevo metodo para al darle al botton
  void addBandToList( String name ) {
    
    //print(name);

    if(name.length > 1) {
      //Podemos agregarlo
      // this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ));
      // setState(() {});
      
       final socketServices = Provider.of<SocketServices>(context, listen:false);

      //ahora agregaremos el nombre de la banda
       socketServices.emit('add-band', {
          'name' : name
       });

    }

   
    //luego cerramos el dialogo
    Navigator.pop(context);
  }


  //mostrar grafica

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
      //dataMap.putIfAbsent('flutter', () => 5);
       
       //forEach hacemos un recorrido de todas las bandas
      bands.forEach((band) { 
         dataMap.putIfAbsent(band.name, () => band.votes.toDouble() );
      });

      final List<Color> colorList = [
          Colors.blue[50]!,
          Colors.blue[200]!,
          Colors.pink[50]!,
          Colors.pink[200]!,
          Colors.yellow[50]!,
          
      ];
      

      return Container(
        padding: EdgeInsets.only(top: 1),
        width: double.infinity,
        height: 200,
       // child: PieChart(dataMap: dataMap)
        child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              //este es para cambiar el estilo ejempo disc
              chartType: ChartType.disc,
              ringStrokeWidth: 32,
              centerText: "Bandas",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 0,
              ),
            ),
      );
  }
  
}