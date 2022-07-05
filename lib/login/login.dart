import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller/main/mainmenu.dart';
import 'package:seller/model/login_model.dart';
import 'package:seller/model/login_result_model.dart';
import 'package:seller/repository/seller.repository.dart';
import 'package:seller/services/seller_service.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
    Login({Key? key}) : super(key: key);

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    TextEditingController textCodeController = TextEditingController();
    TextEditingController textPassController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    SellerService sellerService =
        SellerService(repository: SellerRepository(httpClient: http.Client()));

    loginPress() async {
        LoginDto loginDto =
            LoginDto(textCodeController.text, textPassController.text);

        LoginResultDto resultLogin = await sellerService.loginSeller(loginDto);

        await sellerService.getByCode();

        debugPrint('Service : Login press');
        // CustomerService customerService = CustomerService(
        //     customerRepository: CustomerRepository(httpClient: http.Client()));

        // String resultLogin = await customerService.loginCustomer(
        //     textEmailController.text, textPasswordController.text);

        if (resultLogin.errCode != "00") {
        Fluttertoast.showToast(
            msg: "Login Failed !" + resultLogin.errDesc,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[300],
            textColor: Colors.white70,
            fontSize: 20.0);
        return;
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainMenu()));
        return;
    }

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: loginPage(),
        );
    }

    Widget loginPage() {
        return Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Center(
                    child: Text("logo"),
                )),
            Flexible(flex: 3, child: inputPanel()),
            // Flexible(flex: 1, child: Container())
            ],
        ),
        );
    }

    Widget inputPanel() {
        return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [inputCodeSeller(), inputPassword(), btnLogin()],
            ),
        ),
        );
    }

    Widget inputCodeSeller() {
        return TextFormField(
        validator: (value) {
            if (value == null || value.isEmpty) {
            return 'Please enter some text';
            }
            return null;
        },
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
            icon: Icon(Icons.account_circle)),
        );
    }

    Widget inputPassword() {
        return TextField(
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
            icon: Icon(Icons.vpn_key_rounded)),
        );
    }

    Widget btnLogin() {
        return Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(22.0),
            color: Colors.blue.shade900,
            child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
                if (_formKey.currentState!.validate()) {
                loginPress();
                }
            },
            child: const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            ),
        ),
        );
    }
}
