import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

class SignupLinkDialog extends StatelessWidget {
  const SignupLinkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints.loose(const Size(double.infinity, 500)),
            color: Colors.pink,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: addSeparators([
                    Container(
                      height: 60,
                      width: 30,
                      color: Colors.green,
                    ),
                    Container(
                      height: 60,
                      width: 30,
                      color: Colors.green,
                    ),
                    Container(
                      height: 60,
                      width: 30,
                      color: Colors.green,
                    ),
                    Container(
                      height: 60,
                      width: 30,
                      color: Colors.green,
                    ),
                    Container(
                      height: 60,
                      width: 30,
                      color: Colors.green,
                    ),
                    Container(
                      height: 60,
                      width: 30,
                      color: Colors.green,
                    ),
                  ],Divider(thickness: 20,)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
