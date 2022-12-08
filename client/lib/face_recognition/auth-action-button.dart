import 'package:alan_voice/alan_voice.dart';
import 'package:client/locator.dart';
import 'db_helper.dart';
import 'user_model.dart';
// import 'package:face_net_authentication/pages/profile.dart';
import 'app_button.dart';
import 'camera_service.dart';
import 'ml_services.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
// import '../home.dart';
import 'app_text_field.dart';
import 'package:client/main_menu.dart';
import 'package:client/tts.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');

  User? predictedUser;
  _AuthActionButtonState(){
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "capture":
        onTap();
        break;
    }
  }

  Future _signUp(context) async {
    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    List predictedData = _mlService.predictedData;
    print('/////////////////////////////////////////////////////////////////////////////////////');
    print(predictedData);
    print('/////////////////////////////////////////////////////////////////////////////////////');
    String user = _userTextEditingController.text;
    // String password = _passwordTextEditingController.text;
    User userToSave = User(
      user: user,
      modelData: predictedData,
    );
    await _databaseHelper.insert(userToSave);
    this._mlService.setPredictedData([]);
    Navigator.pop(context);
  }

  Future _signIn(context) async {
    // String password = _passwordTextEditingController.text;
    // if (this.predictedUser!.password == password) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (BuildContext context) => Profile(
    //                 this.predictedUser!.user,
    //                 imagePath: _cameraService.imagePath!,
    //               )));
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text('Wrong password!'),
    //       );
    //     },
    //   );
    // }
  }

  Future<User?> _predictUser() async {
    User? userAndPass = await _mlService.predict();
    return userAndPass;
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        if (widget.isLogin) {
          var user = await _predictUser();
          if (user != null) {
            this.predictedUser = user;
          }
        }
        PersistentBottomSheetController bottomSheetController =
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Container(
                  child: Text(
                    'Welcome back, ' + predictedUser!.user + '.',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : widget.isLogin
                  ? Container(
                      child: Text(
                      'User not found 😞',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
          Container(
            child: Column(
              children: [
                !widget.isLogin
                    ? AppTextField(
                        controller: _userTextEditingController,
                        labelText: "Name of the person",
                      )
                    : Container(),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? AppButton(
                        text: 'LOGIN',
                        onPressed: () async {
                          _signIn(context);
                        },
                        icon: Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      )
                    : !widget.isLogin
                        ? AppButton(
                            text: 'Register',
                            onPressed: () async {
                              await _signUp(context);
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
