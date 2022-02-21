import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';

class ResearchBar extends StatefulWidget {
  const ResearchBar({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _ResearchBarState createState() => _ResearchBarState();
}

class _ResearchBarState extends State<ResearchBar> {
  bool selected = false;
  bool _initialized = false;
  final AnimateIconController controller = AnimateIconController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AnimatedContainer(
        height: selected == true ? 220 : 100,
        color: Colors.white,
        duration: const Duration(milliseconds: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Filtra',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: AnimateIcons(
                    startIcon: Icons.arrow_drop_down,
                    endIcon: Icons.arrow_drop_up,
                    size: 30.0,
                    controller: controller,
                    // add this tooltip for the start icon
                    startTooltip: 'Icons.add_circle',
                    // add this tooltip for the end icon
                    endTooltip: 'Icons.add_circle_outline',
                    onStartIconPress: () {
                      setState(() {
                        selected = !selected;
                      });

                      _initialize();

                      return true;
                    },
                    onEndIconPress: () {
                      setState(() {
                        selected = !selected;

                        _initialized = false;
                      });
                      return true;
                    },
                    duration: Duration(milliseconds: 500),

                    clockwise: false,
                  ),
                ),
              ],
            ),
            _initialized
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: widget.child),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
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
                                    'Ripulisci',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _initialize() {
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Check that the widget is still mounted
        setState(() {
          _initialized = true;
        });
      }
    });
  }
}
