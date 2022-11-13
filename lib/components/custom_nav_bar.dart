import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:my_boilerplate/constantes/constantes.dart';
import 'package:my_boilerplate/translations/app_localizations.dart';

class CustomNavBar extends ConsumerStatefulWidget {
  final TabController tabController;

  const CustomNavBar({Key? key, required this.tabController}) : super(key: key);

  @override
  CustomNavBarState createState() => CustomNavBarState();
}

class CustomNavBarState extends ConsumerState<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0.0, -10.0),
                  )
                ]),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (!widget.tabController.indexIsChanging) {
                      if (widget.tabController.index == 0) {
                        navHomeKey!.currentState!
                            .popUntil((route) => route.isFirst);
                      } else {
                        setState(() {
                          widget.tabController.animateTo(0);
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        size: 30,
                        color: widget.tabController.index == 0
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        AppLocalization.of(context)
                            .translate("general", "home"),
                        style: textStyleCustomRegular(
                            widget.tabController.index == 0
                                ? Colors.blue
                                : Colors.grey,
                            12),
                            textScaleFactor: 1.0
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (!widget.tabController.indexIsChanging) {
                      if (widget.tabController.index == 1) {
                        navChatKey!.currentState!
                            .popUntil((route) => route.isFirst);
                      } else {
                        setState(() {
                          widget.tabController.animateTo(1);
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        size: 30,
                        color: widget.tabController.index == 1
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        AppLocalization.of(context)
                            .translate("general", "chat"),
                        style: textStyleCustomRegular(
                            widget.tabController.index == 1
                                ? Colors.blue
                                : Colors.grey,
                            12),
                            textScaleFactor: 1.0
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (!widget.tabController.indexIsChanging) {
                      if (widget.tabController.index == 2) {
                        navNotificationsKey!.currentState!
                            .popUntil((route) => route.isFirst);
                      } else {
                        setState(() {
                          widget.tabController.animateTo(2);
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_active,
                        size: 30,
                        color: widget.tabController.index == 2
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        AppLocalization.of(context)
                            .translate("general", "notifications"),
                        style: textStyleCustomRegular(
                            widget.tabController.index == 2
                                ? Colors.blue
                                : Colors.grey,
                            12),
                            textScaleFactor: 1.0
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (!widget.tabController.indexIsChanging) {
                      if (widget.tabController.index == 3) {
                        navProfileKey!.currentState!
                            .popUntil((route) => route.isFirst);
                      } else {
                        setState(() {
                          widget.tabController.animateTo(3);
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 30,
                        color: widget.tabController.index == 3
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        AppLocalization.of(context)
                            .translate("general", "profile"),
                        style: textStyleCustomRegular(
                            widget.tabController.index == 3
                                ? Colors.blue
                                : Colors.grey,
                            12),
                            textScaleFactor: 1.0
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}
