import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table/utils/Utlils.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';
import 'package:time_table/utils/habit%20tracker/theme_provider.dart';
import 'package:time_table/utils/user_info.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PersistentBottomSheetController? _controller; // <------ Instance variable
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = Prefrences.getuserName();
  int selectedIndex = Prefrences.getSavedDP();

  int profileIndex() {
    return Prefrences.getSavedDP();
  }

  String getName() {
    return Prefrences.getuserName();
  }

  void openPlayStore() {
    String url =
        "https://play.google.com/store/apps/details?id=com.scarecrowhouse.activity_tracker";
    Utils.openLinks(url: Uri.encodeFull(url));
  }

  void openMail() {
    Utils.openEmail(
        to: "scarecrowhouse7@gmail.com", subject: "Feeback for Track and grow");
  }

  void openPrivacyPolicy() {
    String url = "https://trackandgrow.blogspot.com/2021/07/privacypolicy.html";
    Utils.openLinks(url: Uri.encodeFull(url));
  }

  void saveProfilePhoto(BuildContext context, int index) async {
    _controller = _scaffoldKey.currentState!.showBottomSheet<void>(
      (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 10, right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text(
                  "Enter your Name",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: name),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      if (value != "") {
                        name = value;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      fillColor: Colors.black12,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                    ),
                    maxLength: 10,
                  ),
                ),
                Divider(),
                Text(
                  "Chose your Avatar",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final user = Provider.of<User>(context, listen: false);
                        user.updateDP(selectedIndex);
                        if (name != "") {
                          user.updateName(name);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget imageAvatar({required int index}) {
    return GestureDetector(
      onTap: () {
        _controller!.setState!(() {
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
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  child: Consumer<User>(
                    builder: (_, user, __) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              saveProfilePhoto(context, profileIndex());
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage(
                                  'assets/profilePictures/${user.getProfilePic}.png'),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            user.getName,
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "App",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Consumer<ThemeManager>(builder:
                          (BuildContext context, theme, Widget? child) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(right: 20),
                          leading: Icon(Prefrences.getSavedTheme() == 0
                              ? Icons.dark_mode
                              : Icons.light_mode),
                          title: Text(
                            "Dark/Light Mode",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: CupertinoSwitch(
                            value:
                                Prefrences.getSavedTheme() == 0 ? true : false,
                            onChanged: (value) {
                              Prefrences.saveTheme(value ? 1 : 0);
                              if (value == false) {
                                theme.updateTheme(ThemeType.LightTheme);
                              } else {
                                theme.updateTheme(ThemeType.DarkTheme);
                              }
                            },
                          ),
                        );
                      }),
                      Divider(),
                      Text(
                        "Help",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          openMail();
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.only(right: 20),
                          leading: Icon(
                            Icons.mail,
                          ),
                          title: Text(
                            "Contact us",
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text("Suggestions/Feedback/Bugs"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          openPrivacyPolicy();
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.only(right: 20),
                          leading: Icon(Icons.policy),
                          title: Text(
                            "Privacy Policy",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Divider(),
                      Text(
                        "About",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          openPlayStore();
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.only(right: 20),
                          leading: Icon(
                            Icons.star,
                          ),
                          title: Text(
                            "Rate us",
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text("Your 5 Stars means a lot"),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(right: 20),
                        leading: Icon(
                          Icons.info,
                        ),
                        title: Text(
                          "App Version",
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text("3.0.0"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}