import 'package:flutter/material.dart';

class CustomDeleteDialogBox extends StatefulWidget {
  final String title;

  final String primaryButtonTitle;
  final Function primaryButtonDidTapHandler;
  BuildContext? contextt;
  Widget? child;

  String? secondaryButtonTitle;
  Function? secondaryButtonDidTapHandler;

  CustomDeleteDialogBox(
      {Key? key,
      required this.title,
      required this.primaryButtonTitle,
      required this.primaryButtonDidTapHandler,
      this.secondaryButtonTitle,
      this.secondaryButtonDidTapHandler,
      this.child,
      this.contextt})
      : super(key: key);

  @override
  _CustomDeleteDialogBoxState createState() => _CustomDeleteDialogBoxState();
}

class _CustomDeleteDialogBoxState extends State<CustomDeleteDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        width: 800,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [widget.child ?? Container()],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.secondaryButtonTitle != null
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.secondaryButtonDidTapHandler!();
                            },
                            child: Container(
                              height: 50,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.secondaryButtonTitle ?? '',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pop();
                        widget.primaryButtonDidTapHandler();
                      },
                      child: Container(
                        height: 50,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.primaryButtonTitle,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
