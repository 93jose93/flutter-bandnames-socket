
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
  factory Band.fromMap( Map<String, dynamic> obj) =>  Band(

    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']

  );

}