import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_table/Widgets/firebase/show_exception_widget.dart';
import 'package:time_table/firebase/cloud_store.dart';
import 'package:time_table/firebase/firebase_authentication.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

import 'package:time_table/utils/Utlils.dart';
import 'package:time_table/utils/prefrences.dart';
import 'package:time_table/utils/theme_provider.dart';
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

  Future<void> createHabitBackup(BuildContext context) async {
    final CloudData cloudData = Provider.of<CloudData>(context, listen: false);
    final habitbox = HabitBox.getHabitBox();
    final List<Habit> habits = habitbox.values.toList();
    if (habits.isNotEmpty) {
      openLoadingScafold(message: "Creating Backup");
      await cloudData.deleteHabitData();

      try {
        for (var habit in habits) {
          await cloudData.uploadHabitData(habit.toMap());
        }
        ScaffoldMessenger.of(context).clearSnackBars();
      } on PlatformException catch (e) {
        showExceptionAlertDialog(context,
            title: "Unknown Error Occured", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      } on SocketException catch (e) {
        showExceptionAlertDialog(context,
            title: "Please connect To the Internet", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      } on firebaseAuth.FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: "Something Went Wrong ", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      } on Exception catch (e) {
        showExceptionAlertDialog(context,
            title: "Something Went Wrong ", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    }
  }

  Future<void> restoreBackup(BuildContext context) async {
    final CloudData cloudData = Provider.of<CloudData>(context, listen: false);
    openLoadingScafold(message: "Restoring");

    final restoredHabits = await cloudData.getHabitData();
    ScaffoldMessenger.of(context).clearSnackBars();
    if (restoredHabits != []) {
      try {
        for (var habit in restoredHabits) {
          HabitBox.getHabitBox().put(habit.title, habit);
        }
      } on PlatformException catch (e) {
        showExceptionAlertDialog(context,
            title: "No Internet Connection", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      } on SocketException catch (e) {
        showExceptionAlertDialog(context,
            title: "No Internet Connection", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      } on firebaseAuth.FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: "Something Went Wrong ", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      } on Exception catch (e) {
        showExceptionAlertDialog(context,
            title: "Something Went Wrong ", exception: e);
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    }
  }

  void _googleSignIn(BuildContext context) async {
    try {
      openLoadingScafold(message: "Signing In");
      await FirebaseAuthentication.signInWithGoogle();
      ScaffoldMessenger.of(context).clearSnackBars();
    } on PlatformException catch (e) {
      showExceptionAlertDialog(context,
          title: "No Internet Connection", exception: e);
      ScaffoldMessenger.of(context).clearSnackBars();
    } on SocketException catch (e) {
      showExceptionAlertDialog(context,
          title: "No Internet Connection", exception: e);
      ScaffoldMessenger.of(context).clearSnackBars();
    } on firebaseAuth.FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context,
          title: "Something Went Wrong ", exception: e);
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }

  void openLoadingScafold({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: Colors.blue,
          ),
          SizedBox(
            width: 5,
          ),
          Text(message),
        ],
      ),
      duration: const Duration(seconds: 50),
    ));
  }

  void openEditScafold(BuildContext context, double deviceWidth) async {
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
                  style: TextStyle(
                      fontSize: deviceWidth / 14, fontWeight: FontWeight.bold),
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
                  style: TextStyle(
                      fontSize: deviceWidth / 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    imageAvatar(index: 1, deviceWidth: deviceWidth),
                    imageAvatar(index: 2, deviceWidth: deviceWidth),
                    imageAvatar(index: 3, deviceWidth: deviceWidth),
                    imageAvatar(index: 4, deviceWidth: deviceWidth),
                    imageAvatar(index: 5, deviceWidth: deviceWidth),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    imageAvatar(index: 6, deviceWidth: deviceWidth),
                    imageAvatar(index: 7, deviceWidth: deviceWidth),
                    imageAvatar(index: 8, deviceWidth: deviceWidth),
                    imageAvatar(index: 9, deviceWidth: deviceWidth),
                    imageAvatar(index: 10, deviceWidth: deviceWidth),
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
                            fontSize: deviceWidth / 24,
                            fontWeight: FontWeight.bold),
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
                            fontSize: deviceWidth / 24,
                            fontWeight: FontWeight.bold),
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

  Widget imageAvatar({required int index, required double deviceWidth}) {
    return GestureDetector(
      onTap: () {
        _controller!.setState!(() {
          selectedIndex = index;
        });
      },
      child: CircleAvatar(
        radius: selectedIndex == index ? deviceWidth / 8 : deviceWidth / 14,
        backgroundImage: AssetImage('assets/profilePictures/$index.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
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
                            openEditScafold(context, deviceWidth);
                          },
                          child: CircleAvatar(
                            radius: deviceWidth / 8,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage(
                                'assets/profilePictures/${user.getProfilePic}.png'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          user.getName,
                          style: TextStyle(
                              fontSize: deviceWidth / 12,
                              fontWeight: FontWeight.bold),
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
                      "Backup/Restore",
                      style: TextStyle(
                          fontSize: deviceWidth / 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<String>(
                      stream: FirebaseAuthentication.getUserStream,
                      builder: (context, snapshot) {
                        var uid = snapshot.data;
                        if (uid == "") {
                          return InkWell(
                            onTap: () {
                              _googleSignIn(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: deviceWidth / 9,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: deviceWidth / 9,
                                    width: deviceWidth / 9,
                                    color: Colors.white,
                                    child:
                                        Image.asset("assets/images/google.png"),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Sign In With Google",
                                    style: TextStyle(
                                        fontSize: deviceWidth / 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                createHabitBackup(context);
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.cloud_download),
                                title: Text(
                                  "Create Backup",
                                  style: TextStyle(fontSize: deviceWidth / 22),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                restoreBackup(context);
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.restore),
                                title: Text(
                                  "Restore",
                                  style: TextStyle(fontSize: deviceWidth / 22),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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
                          fontSize: deviceWidth / 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Consumer<ThemeManager>(
                        builder: (BuildContext context, theme, Widget? child) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(right: 20),
                        leading: Icon(Prefrences.getSavedTheme() == 0
                            ? Icons.dark_mode
                            : Icons.light_mode),
                        title: Text(
                          "Dark/Light Mode",
                          style: TextStyle(fontSize: deviceWidth / 22),
                        ),
                        trailing: CupertinoSwitch(
                          value: Prefrences.getSavedTheme() == 0 ? true : false,
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
                    StreamBuilder<String>(
                        stream: FirebaseAuthentication.getUserStream,
                        builder: (context, snapshot) {
                          var uid = snapshot.data;

                          if (uid != "") {
                            return InkWell(
                              onTap: () {
                                FirebaseAuthentication.signOut();
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.logout),
                                title: Text(
                                  "Logout",
                                  style: TextStyle(fontSize: deviceWidth / 22),
                                ),
                              ),
                            );
                          }
                          return SizedBox(height: 0);
                        }),
                    Divider(),
                    Text(
                      "Help",
                      style: TextStyle(
                          fontSize: deviceWidth / 14,
                          fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: deviceWidth / 22),
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
                          style: TextStyle(fontSize: deviceWidth / 22),
                        ),
                      ),
                    ),
                    Divider(),
                    Text(
                      "About",
                      style: TextStyle(
                          fontSize: deviceWidth / 14,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        openPlayStore();
                      },
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.only(right: deviceWidth / 22),
                        leading: Icon(
                          Icons.star,
                        ),
                        title: Text(
                          "Rate us",
                          style: TextStyle(fontSize: deviceWidth / 22),
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
                        style: TextStyle(fontSize: deviceWidth / 22),
                      ),
                      subtitle: Text("3.0.1"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
