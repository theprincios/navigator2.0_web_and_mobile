import 'package:flutter/material.dart';

class PageBar extends StatelessWidget {
  const PageBar(
      {Key? key,
      this.actioName,
      this.primaryButtonDidTapHandler,
      this.pageName})
      : super(key: key);

  final String? pageName;
  final String? actioName;
  final Function? primaryButtonDidTapHandler;

  // final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          margin: const EdgeInsets.all(16.00),
          child: Text(
            pageName ?? '',
            style: const TextStyle(
                fontSize: 40, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
        actioName != null
            ? GestureDetector(
                onTap: () => primaryButtonDidTapHandler!.call(),
                child: Container(
                  margin: const EdgeInsets.all(16.00),
                  height: 50,
                  width: 210,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      actioName!,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            : Container()
      ]),
    );
  }
}
