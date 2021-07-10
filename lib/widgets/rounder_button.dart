import 'package:flutter/material.dart';

class RounderButtonWidget extends StatelessWidget {
  final Color color, textColor;
  final Function press;
  final String text;
  final double ratioW;
  const RounderButtonWidget({Key key, this.color = Colors.deepPurpleAccent, this.press, this.text, this.textColor = Colors.white, this.ratioW = 0.8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * this.ratioW,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
          color: this.color,
          onPressed: this.press,
          child: Text(
            this.text ?? "NONE",
            style: TextStyle(
              color: this.textColor,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),

    );
  }
}
