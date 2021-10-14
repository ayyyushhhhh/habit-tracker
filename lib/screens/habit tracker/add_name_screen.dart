import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_table/screens/home_page.dart';
import 'package:time_table/utils/prefrences.dart';

class AddNameScreen extends StatefulWidget {
  const AddNameScreen({Key? key}) : super(key: key);

  @override
  _AddNameScreenState createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> {
  String? userName;
  int selectedIndex = 1;

  Widget imageAvatar({required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: CircleAvatar(
        radius: selectedIndex == index ? 55 : 30,
        backgroundImage: AssetImage('assets/profilePictures/$index.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              if (userName != null && userName != "") {
                Prefrences.saveName(userName.toString());
                Prefrences.saveDP(selectedIndex);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: new Text("Enter your Name"),
                    content: new Text("Entered name is not valid"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Ok"),
                      )
                    ],
                  ),
                );
              }
            },
            child: Text(
              "Let's Go",
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Chose your Avatar",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imageAvatar(index: 1),
                imageAvatar(index: 2),
                imageAvatar(index: 3),
                imageAvatar(index: 4),
                imageAvatar(index: 5),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imageAvatar(index: 6),
                imageAvatar(index: 7),
                imageAvatar(index: 8),
                imageAvatar(index: 9),
                imageAvatar(index: 10),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please Enter Your Name",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  userName = value;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    hintText: "Enter Your First Name "),
                maxLength: 10,
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
