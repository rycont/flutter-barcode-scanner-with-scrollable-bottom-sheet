import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("CU광동편의점에서"), Text("1700원을 결제합니다")],
        ),
      ),
    );
  }
}
