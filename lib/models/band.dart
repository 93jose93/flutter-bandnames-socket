
class Band {

   String id;
   String name;
   int votes;

  Band({
     required this.id,
     required this.name,
     this.votes = 0,
  });

  //factory costructor, recibe argumentos, regresa una nueva instancia de la class Band
  
  //este no sirve por que despues pódemos utilizarlo en cualquier lado con  Band.fromMap
  //este es el mapa que se costruyo en el servidor y aqui se recibira
  factory Band.fromMap( Map<String, dynamic> obj) =>  Band(
    //se le agrego una validacion que si no trae el id entonces, muestre ejemplo no-id
    id   : obj.containsKey('id') ? obj['id'] : 'no-id',
    name : obj.containsKey('name') ? obj['name'] : 'no-name',
    votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes',
  );

}