// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
  late PersistentBottomSheetController?
      _controller; // <------ Instance variable
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
    const String url =
        "https://play.google.com/store/apps/details?id=com.scarecrowhouse.activity_tracker";
    Utils.openLinks(url: Uri.encodeFull(url));
  }

  void openMail() {
    Utils.openEmail(
      to: "scarecrowhouse7@gmail.com",
      subject: "Feeback for Track and grow",
    );
  }

  void openSurvey() {
    const String url = "https://forms.gle/ftUP777YYjaTnb4b7";
    Utils.openLinks(url: Uri.encodeFull(url));
  }

  void openPrivacyPolicy() {
    const String url =
        "https://trackandgrow.blogspot.com/2021/07/privacypolicy.html";
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
        for (final habit in habits) {
          await cloudData.uploadHabitData(habit.toMap());
        }

        ScaffoldMessenger.of(context).clearSnackBars();
      } on PlatformException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Unknown Error Occured",
          exception: e,
        );

        ScaffoldMessenger.of(context).clearSnackBars();
      } on SocketException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Please connect To the Internet",
          exception: e,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
      } on firebase_auth.FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Something Went Wrong ",
          exception: e,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
      } on Exception catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Something Went Wrong ",
          exception: e,
        );
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
        for (final habit in restoredHabits) {
          HabitBox.getHabitBox().put(habit.title, habit);
        }
      } on PlatformException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "No Internet Connection",
          exception: e,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
      } on SocketException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "No Internet Connection",
          exception: e,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
      } on firebase_auth.FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Something Went Wrong ",
          exception: e,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
      } on Exception catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Something Went Wrong ",
          exception: e,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    }
  }

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      openLoadingScafold(message: "Signing In");
      await FirebaseAuthentication.signInWithGoogle();
      ScaffoldMessenger.of(context).clearSnackBars();
    } on PlatformException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "No Internet Connection",
        exception: e,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
    } on SocketException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "No Internet Connection",
        exception: e,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
    } on firebase_auth.FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Something Went Wrong ",
        exception: e,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }

  void openLoadingScafold({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 50),
      ),
    );
  }

  Future<void> openEditScafold(BuildContext context, double deviceWidth) async {
    _controller = _scaffoldKey.currentState!.showBottomSheet<void>(
      (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(
                  "Enter your Name",
                  style: TextStyle(
                    fontSize: deviceWidth / 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
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
                      contentPadding: const EdgeInsets.all(20),
                      fillColor: Colors.black12,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLength: 10,
                  ),
                ),
                const Divider(),
                Text(
                  "Chose your Avatar",
                  style: TextStyle(
                    fontSize: deviceWidth / 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
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
                const SizedBox(
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
                const SizedBox(
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
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
                          fontWeight: FontWeight.bold,
                        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                child: Consumer<User>(
                  builder: (_, user, __) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            openEditScafold(context, deviceWidth);
                          },
                          child: CircleAvatar(
                            radius: deviceWidth / 8,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage(
                              'assets/profilePictures/${user.getProfilePic}.png',
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          user.getName,
                          style: TextStyle(
                            fontSize: deviceWidth / 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<String>(
                      stream: FirebaseAuthentication.getUserStream,
                      builder: (context, snapshot) {
                        final uid = snapshot.data;
                        if (uid == "") {
                          return InkWell(
                            onTap: () {
                              _googleSignIn(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: deviceWidth / 9,
                              decoration: const BoxDecoration(
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
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Sign In With Google",
                                    style: TextStyle(
                                      fontSize: deviceWidth / 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                leading: const Icon(Icons.cloud_download),
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
                                leading: const Icon(Icons.restore),
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
              const Divider(),
              Container(
                margin: const EdgeInsets.only(
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<ThemeManager>(
                      builder: (BuildContext context, theme, Widget? child) {
                        return ListTile(
                          contentPadding: const EdgeInsets.only(right: 20),
                          leading: Icon(
                            Prefrences.getSavedTheme() == 0
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),
                          title: Text(
                            "Dark/Light Mode",
                            style: TextStyle(fontSize: deviceWidth / 22),
                          ),
                          trailing: CupertinoSwitch(
                            value: Prefrences.getSavedTheme() == 0,
                            onChanged: (value) {
                              Prefrences.saveTheme(value ? 1 : 0);
                              if (value == false) {
                                theme.updateTheme(ThemeType.lightTheme);
                              } else {
                                theme.updateTheme(ThemeType.darkTheme);
                              }
                            },
                          ),
                        );
                      },
                    ),
                    StreamBuilder<String>(
                      stream: FirebaseAuthentication.getUserStream,
                      builder: (context, snapshot) {
                        final uid = snapshot.data;

                        if (uid != "") {
                          return InkWell(
                            onTap: () {
                              FirebaseAuthentication.signOut();
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.logout),
                              title: Text(
                                "Logout",
                                style: TextStyle(fontSize: deviceWidth / 22),
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 0);
                      },
                    ),
                    const Divider(),
                    Text(
                      "Help",
                      style: TextStyle(
                        fontSize: deviceWidth / 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openMail();
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(right: 20),
                        leading: const Icon(
                          Icons.mail,
                        ),
                        title: Text(
                          "Contact us",
                          style: TextStyle(fontSize: deviceWidth / 22),
                        ),
                        subtitle: const Text("Suggestions/Feedback/Bugs"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openPrivacyPolicy();
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(right: 20),
                        leading: const Icon(Icons.policy),
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: deviceWidth / 22),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openSurvey();
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(right: 20),
                        leading: const Icon(Icons.note),
                        title: Text(
                          "Survey",
                          style: TextStyle(fontSize: deviceWidth / 22),
                        ),
                        subtitle: const Text(
                            "Please Fill this survey for future updates"),
                      ),
                    ),
                    const Divider(),
                    Text(
                      "About",
                      style: TextStyle(
                        fontSize: deviceWidth / 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openPlayStore();
                      },
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.only(right: deviceWidth / 22),
                        leading: const Icon(
                          Icons.star,
                        ),
                        title: Text(
                          "Rate us",
                          style: TextStyle(fontSize: deviceWidth / 22),
                        ),
                        subtitle: const Text("Your 5 Stars means a lot"),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.only(right: 20),
                      leading: const Icon(
                        Icons.info,
                      ),
                      title: Text(
                        "App Version",
                        style: TextStyle(fontSize: deviceWidth / 22),
                      ),
                      subtitle: const Text("5.0.0"),
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
