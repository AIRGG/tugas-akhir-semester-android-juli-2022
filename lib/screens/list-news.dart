import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project4_adblock_android/models/News.dart';
import 'package:project4_adblock_android/screens/add-news.dart';
import 'package:project4_adblock_android/screens/edit-news.dart';
import 'package:http/http.dart' as http;

class ListNewsScreen extends StatefulWidget {
  ListNewsScreen({Key? key}) : super(key: key);

  @override
  State<ListNewsScreen> createState() => _ListNewsScreenState();
}

class _ListNewsScreenState extends State<ListNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List News")),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                // SizedBox(height: 30),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: FloatingActionButton(
          elevation: 8,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            // print('halaman add');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewsScreen()),
            );
          },
        ),
      ),
    );
  }
}

final kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

class ProfileListItems extends StatelessWidget {
  @override
  void initState() {
    // super.initState();
    getRequest();
  }

  Future<List<News>> getRequest() async {
    //replace your restFull API here.
    String url =
        "http://${dotenv.env['api_host'].toString()}/Project4-Adblock-integration/list-data-android.php";
    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);
    // print(responseData);

    // //Creating a list to store input data;
    List<News> news = [];
    news =
        (responseData as List).map((data) => new News.fromJson(data)).toList();
    print(news);
    print(news[0].title);
    // for (var singleUser in responseData) {
    //   News user = News(
    //       id: singleUser["id"],
    //       userId: singleUser["userId"],
    //       title: singleUser["title"],
    //       body: singleUser["body"]);

    //   //Adding user to the list.
    //   users.add(user);
    // }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // child: ListView(
      //   children: <Widget>[
      //     InkWell(
      //       onLongPress: () => {
      //         showAlertDialog(context),
      //       },
      //       onTap: () => {
      //         // Navigator.pushReplacementNamed(context, '/login')
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => EditNewsScreen()),
      //         // )
      //         getRequest()
      //       },
      //       child: ProfileListItem(
      //         icon: Icons.person,
      //         text: 'Budiantoro',
      //         hasNavigation: false,
      //       ),
      //     ),
      //     InkWell(
      //       onTap: () => {
      //         // Navigator.pushReplacementNamed(context, '/login')
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => EditNewsScreen()),
      //         )
      //       },
      //       child: ProfileListItem(
      //         icon: Icons.person,
      //         text: 'Bambang',
      //         hasNavigation: false,
      //       ),
      //     ),
      //   ],
      // ),
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot projectSnap) {
          if (projectSnap.data == null) {
            if (!projectSnap.hasData) {
              return Container(
                child: Center(child: Text('Data Empty')),
              );
            }
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                News news = projectSnap.data[index];
                return Column(
                  children: <Widget>[
                    InkWell(
                      onLongPress: () => {
                        showConfirmationAlertDialog(context, news),
                      },
                      onTap: () => {
                        // Navigator.pushReplacementNamed(context, '/login')
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditNewsScreen(
                                    news: news,
                                  )),
                        )
                        // getRequest()
                      },
                      child: ProfileListItem(
                        icon: Icons.newspaper,
                        text: news.title!,
                        hasNavigation: false,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        future: getRequest(),
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
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

  showConfirmationAlertDialog(BuildContext context, News news) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Map data = {
          'save': '1',
          'delete': news.id.toString(),
        };
        Map<String, String> headers = {
          "Content-Type": "application/x-www-form-urlencoded",
        };

        String url =
            "http://${dotenv.env['api_host'].toString()}/Project4-Adblock-integration/delete-data-android.php";
        final response =
            await http.post(Uri.parse(url), body: data, headers: headers);
        Navigator.of(context).pop();
        await showAlertDialog(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure?"),
      actions: [
        cancelButton,
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
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(
        bottom: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            this.icon,
            size: 25,
          ),
          SizedBox(width: 15),
          Text(
            this.text,
            style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500, fontFamily: "Poppins"),
          ),
          Spacer(),
          if (this.hasNavigation)
            Icon(
              Icons.arrow_left,
              size: 25,
            ),
        ],
      ),
    );
  }
}
