import 'dart:ui';

import 'package:age_calculator/age_calculator.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myyoukounkoun/components/cached_network_image_custom.dart';
import 'package:myyoukounkoun/constantes/constantes.dart';
import 'package:myyoukounkoun/helpers/helpers.dart';
import 'package:myyoukounkoun/models/conversation_model.dart';
import 'package:myyoukounkoun/models/user_model.dart';
import 'package:myyoukounkoun/providers/chat_provider.dart';
import 'package:myyoukounkoun/providers/user_provider.dart';
import 'package:myyoukounkoun/route_observer.dart';
import 'package:myyoukounkoun/translations/app_localizations.dart';
import 'package:myyoukounkoun/views/auth/chat_details.dart';

class UserProfile extends ConsumerStatefulWidget {
  final UserModel user;
  final bool bottomNav;

  const UserProfile({Key? key, required this.user, required this.bottomNav})
      : super(key: key);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends ConsumerState<UserProfile> {
  AppBar appBar = AppBar();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _conversationBottomSheet(BuildContext context) async {
    //TODO replace this logic with logic firebase
    ConversationModel? currentConversation;
    bool convWithCurrentUser = false;
    bool convWithOtherUser = false;

    for (ConversationModel conversation
        in ref.read(conversationsNotifierProvider)!) {
      for (var user in conversation.users) {
        if (user["id"] == ref.read(userNotifierProvider).id) {
          convWithCurrentUser = true;
        }
        if (user["id"] == widget.user.id) {
          convWithOtherUser = true;
        }
      }

      if (convWithCurrentUser &&
          convWithOtherUser &&
          (conversation.lastMessageUserId ==
                  ref.read(userNotifierProvider).id ||
              conversation.lastMessageUserId == widget.user.id)) {
        currentConversation = conversation;
      }
    }

    return showMaterialModalBottomSheet(
        context: context,
        expand: true,
        enableDrag: false,
        builder: (context) {
          return RouteObserverWidget(
              name: chatDetails,
              child: ChatDetails(
                  user: widget.user,
                  openWithModal: true,
                  conversation: currentConversation ??
                      ConversationModel(
                          id: "temporary",
                          users: [],
                          lastMessageUserId: 0,
                          lastMessage: "",
                          isLastMessageRead: false,
                          timestampLastMessage: "",
                          typeLastMessage: "",
                          themeConv: [])));
        });
  }

  Future<void> updateFollowUser() async {
    //TODO ws update follow user
    if (ref.read(userNotifierProvider).followings.contains(widget.user.id)) {
      ref.read(userNotifierProvider.notifier).removeFollowing(widget.user.id);
      setState(() {
        widget.user.followers.removeWhere(
            (element) => element == ref.read(userNotifierProvider).id);
      });
    } else {
      ref.read(userNotifierProvider.notifier).addFollowing(widget.user.id);
      setState(() {
        widget.user.followers.add(ref.read(userNotifierProvider).id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size(
              MediaQuery.of(context).size.width, appBar.preferredSize.height),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                systemOverlayStyle: Helpers.uiOverlayApp(context),
                leading: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Helpers.uiApp(context),
                      )),
                ),
                title: Text(
                    "${AppLocalization.of(context).translate("user_profile_screen", "profile_of")} ${widget.user.pseudo}",
                    style: textStyleCustomBold(Helpers.uiApp(context), 20),
                    textScaleFactor: 1.0),
                centerTitle: false,
                actions: [
                  widget.user.id == ref.read(userNotifierProvider).id
                      ? const SizedBox()
                      : Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                              onPressed: () async => await updateFollowUser(),
                              icon: ref
                                      .read(userNotifierProvider)
                                      .followings
                                      .contains(widget.user.id)
                                  ? Icon(Icons.person_remove,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? cBlack
                                          : cWhite,
                                      size: 26)
                                  : Icon(Icons.person_add,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? cBlack
                                          : cWhite,
                                      size: 26)),
                        ),
                  widget.user.id == ref.read(userNotifierProvider).id
                      ? const SizedBox()
                      : Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                              onPressed: () => _conversationBottomSheet(
                                  navAuthKey.currentContext!),
                              icon: Icon(Icons.edit_note,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? cBlack
                                      : cWhite,
                                  size: 33)),
                        )
                ],
              ),
            ),
          ),
        ),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                20.0,
                MediaQuery.of(context).padding.top +
                    appBar.preferredSize.height +
                    20.0,
                20.0,
                widget.bottomNav
                    ? MediaQuery.of(context).padding.bottom + 90.0
                    : MediaQuery.of(context).padding.bottom + 20.0),
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                topUserProfile(),
                const SizedBox(height: 10.0),
                bodyUserProfile()
              ],
            ),
          ),
        ));
  }

  Widget topUserProfile() {
    return Column(
      children: [
        Row(
          children: [
            widget.user.profilePictureUrl.trim() == ""
                ? Container(
                    height: 145,
                    width: 145,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: cBlue),
                      color: cGrey.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.person, color: cBlue, size: 55),
                  )
                : CachedNetworkImageCustom(
                    profilePictureUrl: widget.user.profilePictureUrl,
                    heightContainer: 145,
                    widthContainer: 145,
                    iconSize: 55),
            const SizedBox(width: 25.0),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.pseudo,
                      style: textStyleCustomBold(Helpers.uiApp(context), 20),
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 5.0),
                    Flag.flagsCode
                            .contains(widget.user.nationality.toUpperCase())
                        ? Flag.fromString(
                            widget.user.nationality.toUpperCase(),
                            height: 15,
                            width: 20,
                            fit: BoxFit.contain,
                            replacement: const SizedBox(),
                          )
                        : Flag.flagsCode
                                .contains(widget.user.nationality.toLowerCase())
                            ? Flag.fromString(
                                widget.user.nationality.toLowerCase(),
                                height: 15,
                                width: 20,
                                fit: BoxFit.contain,
                                replacement: const SizedBox(),
                              )
                            : const SizedBox()
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      widget.user.gender == "Male" ? Icons.male : Icons.female,
                      color: Helpers.uiApp(context),
                      size: 20,
                    ),
                    Text(
                      " - ",
                      style: textStyleCustomBold(Helpers.uiApp(context), 16),
                    ),
                    Text(
                        AgeCalculator.age(Helpers.convertStringToDateTime(
                                    widget.user.birthday))
                                .years
                                .toString() +
                            AppLocalization.of(context)
                                .translate("profile_screen", "years_old"),
                        style:
                            textStyleCustomBold(Helpers.uiApp(context), 16.0))
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(
                    "${Helpers.formatNumber(widget.user.followers.length)} Abonné(s)",
                    style: textStyleCustomBold(Helpers.uiApp(context), 14),
                    textScaleFactor: 1.0,
                    maxLines: 2,
                    overflow: TextOverflow.clip),
                const SizedBox(height: 5.0),
                Text(
                    "${Helpers.formatNumber(widget.user.followings.length)} Abonnement(s)",
                    style: textStyleCustomBold(Helpers.uiApp(context), 14),
                    textScaleFactor: 1.0,
                    maxLines: 2,
                    overflow: TextOverflow.clip),
              ],
            ))
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(widget.user.bio,
                style: textStyleCustomMedium(Helpers.uiApp(context), 14),
                textScaleFactor: 1.0),
          ),
        )
      ],
    );
  }

  Widget bodyUserProfile() {
    return Container(
      height: 150.0,
      alignment: Alignment.center,
      child: Text(
        AppLocalization.of(context).translate("general", "message_continue"),
        style: textStyleCustomMedium(Helpers.uiApp(context), 14),
        textAlign: TextAlign.center,
        textScaleFactor: 1.0,
      ),
    );
  }
}
