import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_order_food_app/auth_modal/firebase_auth_modal.dart';
import 'package:multi_order_food_app/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  GlobalKey<FormState> loginFormKey = GlobalKey();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool check;
  checkChange(){
    setState(() {
      check = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check = false;
  }


  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      ),
      inAsyncCall: check,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: _height,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/loginBackground.jpeg"),
                        fit: BoxFit.cover)),
              ),
              Container(
                height: _height,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black12.withOpacity(0.2)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Container(
                  height: _height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      color: Color(0xFF1E2026)),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 28.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 40.0),
                          child: Container(
                            height: 53.5,
                            decoration: BoxDecoration(
                              color: Color(0xFF23252E),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.15,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0, top: 5.0),
                              child: Theme(
                                data: ThemeData(hintColor: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    controller: loginEmailController,
                                    style: new TextStyle(color: Colors.white),
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    autofocus: false,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Field Required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(0.0),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        labelText: 'Email',
                                        hintStyle: TextStyle(color: Colors.white),
                                        labelStyle: TextStyle(
                                          color: Colors.white70,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 15.0),
                          child: Container(
                            height: 53.5,
                            decoration: BoxDecoration(
                              color: Color(0xFF23252E),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.15,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0, top: 5.0),
                              child: Theme(
                                data: ThemeData(hintColor: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    controller: loginPasswordController,
                                    style: new TextStyle(color: Colors.white),
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    autofocus: false,
                                    obscureText: true,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Field Required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(0.0),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        labelText: 'Password',
                                        hintStyle: TextStyle(color: Colors.white),
                                        labelStyle: TextStyle(
                                          color: Colors.white70,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 64.0),
                          child: InkWell(
                            onTap: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if(loginFormKey.currentState.validate()){

                                setState(() {
                                  check = true;
                                });

                                firebaseAuthentication.signInWithEmailAndPassword(checkChange,
                                    loginEmailController.text, loginPasswordController.text);
                              }
                            },
                            child: Container(
                              height: 52.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFFEE140),
                                  Color(0xFFFA709A),
                                ]),
                              ),
                              child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Sofia",
                                        letterSpacing: 0.9),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                new SignUpScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 15.0),
                              ),
                              Text(" Signup",
                                  style: TextStyle(
                                      fontFamily: "Sofia",
                                      color: Color(0xFFFA709A),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
