import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardXL extends StatelessWidget {
  Image? mainImage = Image.asset('assets/images/portico.png');
  String? title;
  String? subtitle;
  String? buttomText;
  Icon? icon;
  final Function buttonDidTapHandler;
  bool buttonDisabled;
  CardXL({
    this.mainImage,
    this.title,
    this.subtitle,
    this.buttomText,
    this.icon,
    this.buttonDisabled = false,
    required this.buttonDidTapHandler,
  });

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);

    mainImage = Image.asset('assets/images/portico.jpg');
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(20),
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              this.subtitle ?? '',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          !buttonDisabled
              ? Container(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      this.buttonDidTapHandler();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        this.buttomText ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
