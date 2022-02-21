import 'package:animate_icons/animate_icons.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class MenagementScreen extends StatefulWidget {
  const MenagementScreen({
    Key? key,
  }) : super(key: key);
  static final LocalKey keyPage = UniqueKey();

  @override
  State<MenagementScreen> createState() => _MenagementScreenState();
}

class _MenagementScreenState extends State<MenagementScreen>
    with SingleTickerProviderStateMixin {
  FlipCardController _controller = FlipCardController();
  bool calendarMode = false;

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool selected = false;
  bool _initialized = false;

  final AnimateIconController controller = AnimateIconController();

  @override
  Widget build(BuildContext context) {
    var dataLayout = MediaQuery.of(context);

    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PageBar(
            actioName: 'Nuovo Appuntamento', primaryButtonDidTapHandler: () {}),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, top: 20.0),
          child: GestureDetector(
            onTap: () => cardKey.currentState!.toggleCard(),
            child: calendarMode
                ? Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Passa alla modalità classica',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Passa alla modalità calendario',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FlipCard(
            flipOnTouch: false,
            // ignore: avoid_types_as_parameter_names
            onFlipDone: (bool) {
              setState(() {
                calendarMode = !calendarMode;
              });
            },
            direction: FlipDirection.VERTICAL,
            controller: _controller,
            key: cardKey,
            front: Container(
              height: dataLayout.size.height,
              child: Card(
                color: Colors.grey[50],
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: dataLayout.size.width - 150,
                  height: dataLayout.size.height - 250,
                  child: ContainedTabBarView(
                    // ignore: prefer_const_constructors
                    tabBarProperties: TabBarProperties(
                      indicatorSize: TabBarIndicatorSize.label,
                      width: 600,
                      alignment: TabBarAlignment.start,
                    ),
                    tabs: const [
                      Text(
                        'CONFERMATI',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Text(
                        'DA CONFERMARE',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      Text(
                        'CHIUSI',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                    views: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AnimatedContainer(
                                height: selected == true ? 220 : 100,
                                color: Colors.white,
                                duration: const Duration(milliseconds: 500),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            endTooltip:
                                                'Icons.add_circle_outline',
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
                                            duration:
                                                Duration(milliseconds: 500),

                                            clockwise: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _initialized
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      height: 50,
                                                      width: 350,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      height: 50,
                                                      width: 350,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 50,
                                                        width: 140,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Ripulisci',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
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
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.all(20.0),
                      ),
                      const Padding(
                        padding: const EdgeInsets.all(20.0),
                      )
                    ],
                    onChange: (index) => print(index),
                  ),
                ),
              ),
            ),
            back: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                width: dataLayout.size.width - 150,
                height: dataLayout.size.height,
                child: Container()),
          ),
        ),
      ],
    ));
  }

  void doStuff() {
    // Flip the card a bit and back to indicate that it can be flipped (for example on page load)
    _controller.hint(
        duration: const Duration(seconds: 2),
        total: const Duration(seconds: 2));

    // Tilt the card a bit (for example when hovering)
    _controller.hint(
        duration: const Duration(seconds: 2),
        total: const Duration(seconds: 2));

    // Flip the card programmatically
    _controller.toggleCard();
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
