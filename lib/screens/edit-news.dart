import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project4_adblock_android/models/News.dart';
import 'package:project4_adblock_android/screens/list-news.dart';

class EditNewsScreen extends StatefulWidget {
  final News? news;

  EditNewsScreen({Key? key, this.news}) : super(key: key);

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  TextEditingController authorController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  @override
  void initState() {
    // super.initState();
    getRequest();
  }

  Future getRequest() async {
    Map data = {
      'author': authorController.text.toString(),
      'judul': judulController.text.toString(),
      'link': linkController.text.toString(),
      'save': '1',
    };
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    String url =
        "http://${dotenv.env['api_host'].toString()}/Project4-Adblock-integration/edit-data-android.php";
    url += '?id=';
    url += widget.news!.id.toString();
    print(url);
    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.body);
    var responseData = json.decode(response.body);
    print(responseData);
    authorController.text = responseData['author'].toString();
    judulController.text = responseData['title'].toString();
    linkController.text = responseData['url'].toString();
    // return news;
  }

  Future saveData(context) async {
    Map data = {
      'author': authorController.text.toString(),
      'judul': judulController.text.toString(),
      'link': linkController.text.toString(),
      'save': '1',
      'id': widget.news!.id.toString(),
    };
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    String url =
        "http://${dotenv.env['api_host'].toString()}/Project4-Adblock-integration/edit-data-android.php";
    final response =
        await http.post(Uri.parse(url), body: data, headers: headers);

    var responseData = json.decode(response.body);
    print(responseData);
    showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListNewsScreen()),
        ).then((result) {
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Success!"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.network('https://picsum.photos/500?image=8'),
      ),
    );

    final txt_author = TextFormField(
      controller: authorController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Author',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final txt_judul = TextFormField(
      controller: judulController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Judul',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final txt_link = TextFormField(
      controller: linkController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Link',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final saveButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          saveData(context);
        },
        padding: EdgeInsets.all(18),
        color: Colors.blue,
        child: Text('Save', style: TextStyle(color: Colors.white)),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Edit News')),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 24.0),
            logo,
            SizedBox(height: 48.0),
            txt_author,
            SizedBox(height: 8.0),
            txt_judul,
            SizedBox(height: 8.0),
            txt_link,
            SizedBox(height: 24.0),
            saveButton,
          ],
        ),
      ),
    );
  }
}
