import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../constants.dart' as Constants;

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: Constants.primaryColor,
                  onSaved: (email) {},
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.person),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
