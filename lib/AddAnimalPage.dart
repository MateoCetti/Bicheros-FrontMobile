import 'package:flutter/material.dart';
import "dart:async";
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http:///192.168.0.21:8000/api/",

);

var dio = Dio(options);

class AddAnimalPage extends StatefulWidget {
  @override
  AddAnimalPageState createState() => new AddAnimalPageState();
}

class AddAnimalPageState extends State<AddAnimalPage>{
  File image;
  var name = new TextEditingController();
  var race = new TextEditingController();
  DateTime dateFounded;
  var placeFounded = new TextEditingController();
  var species = new TextEditingController();
  var gender = false;

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Animal"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(leading: Text("Nombre: "),
            title: TextField(controller: name,),),
          ListTile(leading: Text("Lugar Encontrado: "),
            title: TextField(controller: placeFounded,),),
          ListTile(leading: Text("Fecha Encontrado: "),
            title: dateFounded==null ? Text("Seleccione una fecha") : Text('${dateFounded.day}' + "/" + '${dateFounded.month}' + "/" + '${dateFounded.year}'),
          onTap:() async {
            final newDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (newDate != null && newDate != dateFounded){
              setState(() {
                dateFounded = newDate;

              });
            }
          },),
          ListTile(
            leading: MaterialButton(
              color: Colors.lightBlue,
              onPressed: () => getImage(),
              child: Icon(Icons.image, color: Colors.white,),
            ),
            title: image == null
                ? Text('No image selected.')
                : Text(image.path,
              textAlign: TextAlign.end,),
          ),
          ListTile(leading: Text("Raza: "),
            title: TextField(controller: race,),),
          ListTile(leading: Text("Sexo: "),
            title: Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      gender = !gender;
                    });
                  },
                  child: gender == false
                      ? Text(
                    "Masculino",
                    style: TextStyle(color: Colors.white),
                  )
                      : Text("Femenino", style: TextStyle(color: Colors.white)),
                  color: gender == false ? Colors.lightBlue : Colors.redAccent,
                ),
              ],
            ),),
          ListTile(leading: Text("Especie: "),
            title: TextField(controller: species,),),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        FormData formData = new FormData.from({
          "name": name.text,
          "race": race.text,
          "date_founded": "2019-06-03",
          "place_founded": placeFounded.text,
          "photo": image == null ? null : UploadFileInfo(image, image.path),
          "species": species.text,
          "gender": gender == false ? 0 : 1,
        });
        print(formData);
        dio.post("animals/", data: formData,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain
            )
        ).catchError((error) => print(error));
        Navigator.pop(context);
      },
      child: Icon(Icons.add, color: Colors.white,),),
    );
  }
}