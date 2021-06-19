import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main()=>runApp(MiApp());
class MiApp extends StatelessWidget {
  const MiApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MiApp",
      home: Inicio(),
    );
  }
}
  class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  Future <List<Paises>>getData() async{
    var response = await http.get(
        Uri.parse("https://restcountries.eu/rest/v2/all"),
        headers: {"Accept":"Application/json"}
    );
    var data=json.decode(response.body);
    print(data);
    List<Paises> country=[];
    for(var p in data){
    Paises paises=Paises(p["name"], p["capital"], p["region"]);
    country.add(paises);
  }
  print(country.length);
  return country;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title:Text("Nico App")
    ),
    body: Container(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext  context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if(snapshot.data == null){
            return Container(child: Center(child: Text("Loading..."),),);
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int name){
                return ListTile(title:Text(snapshot.data[name].description),
                subtitle: Text(snapshot.data[name].price.toString()),
                );

              },
               );
          }
        },
      ) ,
      )
    );
  }
}

class Paises {
  final String name;
  final String capital;
  final double region;

  Paises (this.name, this.capital, this.region);
}
