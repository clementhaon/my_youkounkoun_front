import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myyoukounkoun/constantes/constantes.dart';
import 'package:myyoukounkoun/helpers/helpers.dart';
import 'package:myyoukounkoun/translations/app_localizations.dart';

class ConnectivityDevice extends ConsumerStatefulWidget {
  const ConnectivityDevice({Key? key}) : super(key: key);

  @override
  ConnectivityDeviceState createState() => ConnectivityDeviceState();
}

class ConnectivityDeviceState extends ConsumerState<ConnectivityDevice>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Helpers.uiOverlayApp(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Image.asset("assets/images/ic_app_new.png",
                      height: 125, width: 125),
                ),
                const SizedBox(height: 25.0),
                Text(
                  AppLocalization.of(context)
                      .translate("connectivity_screen", "no_connectivity"),
                  style: textStyleCustomMedium(Helpers.uiApp(context), 16),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
