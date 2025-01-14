import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myyoukounkoun/components/cached_network_image_custom.dart';
import 'package:myyoukounkoun/constantes/constantes.dart';
import 'package:myyoukounkoun/helpers/helpers.dart';
import 'package:myyoukounkoun/models/message_model.dart';
import 'package:myyoukounkoun/models/user_model.dart';
import 'package:myyoukounkoun/providers/locale_language_provider.dart';
import 'package:myyoukounkoun/providers/user_provider.dart';

class CarousselPictures extends ConsumerStatefulWidget {
  final List<MessageModel> messagesMedias;
  final MessageModel message;
  final UserModel user;
  final String heroTag;
  final Color? colorTheme;

  const CarousselPictures(
      {Key? key,
      required this.messagesMedias,
      required this.message,
      required this.user,
      required this.heroTag,
      this.colorTheme})
      : super(key: key);

  @override
  CarousselPicturesState createState() => CarousselPicturesState();
}

class CarousselPicturesState extends ConsumerState<CarousselPictures> {
  late PageController _pageController;

  int index = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
        initialPage: widget.messagesMedias.indexOf(widget.message));
    setState(() {
      index = widget.messagesMedias.indexOf(widget.message);
    });

    _pageController.addListener(() {
      if (_pageController.page!.toInt() != index) {
        setState(() {
          index = _pageController.page!.toInt();
        });
      }
    });
  }

  @override
  void deactivate() {
    _pageController.removeListener(() {
      if (_pageController.page!.toInt() != index) {
        setState(() {
          index = _pageController.page!.toInt();
        });
      }
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            PageView.builder(
                controller: _pageController,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                scrollDirection: Axis.horizontal,
                itemCount: widget.messagesMedias.length,
                itemBuilder: (context, index) {
                  MessageModel message = widget.messagesMedias[index];

                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Builder(builder: (_) {
                          return Hero(
                            tag: widget.heroTag,
                            transitionOnUserGestures: true,
                            flightShuttleBuilder: (flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext) {
                              return Image.network(
                                message.message,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    constraints: const BoxConstraints(
                                        maxHeight: 800, maxWidth: 800),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: CircularProgressIndicator(
                                      color: widget.colorTheme ?? cBlue,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    constraints: const BoxConstraints(
                                        maxHeight: 800, maxWidth: 800),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Icon(Icons.replay_outlined,
                                        color: Helpers.uiApp(context),
                                        size: 33),
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              message.message,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width / 2,
                                  constraints: const BoxConstraints(
                                      maxHeight: 800, maxWidth: 800),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: CircularProgressIndicator(
                                    color: widget.colorTheme ?? cBlue,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width / 2,
                                  constraints: const BoxConstraints(
                                      maxHeight: 800, maxWidth: 800),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Icon(Icons.replay_outlined,
                                      color: Helpers.uiApp(context), size: 33),
                                );
                              },
                            ),
                          );
                        })),
                  ));
                }),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 5.0, right: 5.0),
                child: SizedBox(
                  height: 70.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.messagesMedias[index].idSender ==
                              ref.read(userNotifierProvider).id
                          ? Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: GestureDetector(
                                        onTap: () => navAuthKey.currentState!
                                            .pushNamed(userProfile, arguments: [
                                          ref.read(userNotifierProvider),
                                          false
                                        ]),
                                        child: ref
                                                    .read(userNotifierProvider)
                                                    .profilePictureUrl
                                                    .trim() ==
                                                ""
                                            ? Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color:
                                                          widget.colorTheme ??
                                                              cBlue),
                                                  color: cGrey.withOpacity(0.2),
                                                ),
                                                child: Icon(Icons.person,
                                                    color: widget.colorTheme ??
                                                        cBlue,
                                                    size: 15),
                                              )
                                            : CachedNetworkImageCustom(
                                                profilePictureUrl: ref
                                                    .read(userNotifierProvider)
                                                    .profilePictureUrl,
                                                heightContainer: 40,
                                                widthContainer: 40,
                                                iconSize: 15,
                                                colorTheme:
                                                    widget.colorTheme ?? cBlue),
                                      )),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => navAuthKey.currentState!
                                              .pushNamed(userProfile,
                                                  arguments: [
                                                ref.read(userNotifierProvider),
                                                false
                                              ]),
                                          child: Text(
                                              ref
                                                  .read(userNotifierProvider)
                                                  .pseudo,
                                              style: textStyleCustomBold(
                                                  Helpers.uiApp(context), 14),
                                              textScaleFactor: 1.0),
                                        ),
                                        Text(
                                            "${Helpers.formatDateDayWeek(int.parse(widget.messagesMedias[index].timestamp), ref.read(localeLanguageNotifierProvider).languageCode, true)} à ${Helpers.formatDateHoursMinutes(int.parse(widget.messagesMedias[index].timestamp), ref.read(localeLanguageNotifierProvider).languageCode)}",
                                            style:
                                                textStyleCustomBold(cGrey, 14),
                                            textScaleFactor: 1.0)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: GestureDetector(
                                        onTap: () => navAuthKey.currentState!
                                            .pushNamed(userProfile, arguments: [
                                          widget.user,
                                          false
                                        ]),
                                        child: widget.user.profilePictureUrl
                                                    .trim() ==
                                                ""
                                            ? Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color:
                                                          widget.colorTheme ??
                                                              cBlue),
                                                  color: cGrey.withOpacity(0.2),
                                                ),
                                                child: Icon(Icons.person,
                                                    color: widget.colorTheme ??
                                                        cBlue,
                                                    size: 15),
                                              )
                                            : CachedNetworkImageCustom(
                                                profilePictureUrl: widget
                                                    .user.profilePictureUrl,
                                                heightContainer: 40,
                                                widthContainer: 40,
                                                iconSize: 15,
                                                colorTheme:
                                                    widget.colorTheme ?? cBlue),
                                      )),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => navAuthKey.currentState!
                                              .pushNamed(userProfile,
                                                  arguments: [
                                                widget.user,
                                                false
                                              ]),
                                          child: Text(widget.user.pseudo,
                                              style: textStyleCustomBold(
                                                  Helpers.uiApp(context), 14),
                                              textScaleFactor: 1.0),
                                        ),
                                        Text(
                                            "${Helpers.formatDateDayWeek(int.parse(widget.messagesMedias[index].timestamp), ref.read(localeLanguageNotifierProvider).languageCode, true)} à ${Helpers.formatDateHoursMinutes(int.parse(widget.messagesMedias[index].timestamp), ref.read(localeLanguageNotifierProvider).languageCode)}",
                                            style:
                                                textStyleCustomBold(cGrey, 14),
                                            textScaleFactor: 1.0)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          onPressed: () => navAuthKey.currentState!.pop(),
                          icon: Icon(
                            Icons.clear,
                            color: Helpers.uiApp(context),
                            size: 33,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
