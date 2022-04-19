import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

    TextEditingController textCodeController = TextEditingController();
    TextEditingController textPassController = TextEditingController();

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
    }

  @override
    Widget build(BuildContext context) {
        return Scaffold(
        body: loginPage(),
        );
    }

    Widget loginPage() {
        return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Center(
                    child: Text("logo"),
                )),
            Flexible(
                flex: 3, 
                child: inputPanel()
                )
            ],
        );
    }

    Widget inputPanel() {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                inputCodeSeller(),
                inputPassword()
            ],
        );
    }

    Widget inputCodeSeller(){
        return
            TextField(
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black87,
                    ),
                autofocus: true,
                maxLength: 50,
                controller: textCodeController,
                decoration: const InputDecoration(
                    labelText: "Seller code",
                    fillColor: Colors.black87,
                    icon: Icon(Icons.account_circle)
                ),
            );
    }

    Widget inputPassword(){
        return
            TextField(
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black87,
                    ),
                obscureText: true,
                maxLength: 50,
                controller: textPassController,
                decoration: const InputDecoration(
                    labelText: "Password",
                    fillColor: Colors.black87,
                    icon: Icon(Icons.password)
                ),
            );
    }
}
