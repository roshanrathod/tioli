import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final double topRight;
  final double bottomRight;
  final TextEditingController inputController;
  final bool obscureTypedText;
  final String inputHint;

  InputWidget(this.topRight, this.bottomRight, this.obscureTypedText,this.inputHint, this.inputController);

  Widget build(BuildContext context) {
    return Padding (
      padding:  EdgeInsets.only(right:  20, bottom: 20),
      child: Container (
      width: MediaQuery.of(context).size.width -40,
      height: 40,
      child:  Material(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.only(
            bottomRight: Radius.circular(bottomRight),
            topRight: Radius.circular(topRight)
          ) ),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 20,top: 0),
            child: TextField(
              obscureText: obscureTypedText,
              controller: inputController,
              decoration: InputDecoration(
                border: InputBorder.none,   
                hintText: inputHint,             
                hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
      
          ),
            ),
          ),
      ),
      );
  }
}