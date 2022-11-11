import 'dart:io';

import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/functions/crop_image.dart';
import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/functions/show_picker.dart';
import 'package:chat_app/functions/show_toast.dart';
import 'package:chat_app/functions/upload.dart';
import 'package:chat_app/ui/home/home_screen.dart';
import 'package:chat_app/ui/profile_account/profile_account_cubit.dart';
import 'package:chat_app/ui/profile_account/profile_account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../commons/app_commons.dart';

import 'package:image_picker/image_picker.dart';

class ProfileAccountScreen extends StatefulWidget {
  final bool isInSetting;
  const ProfileAccountScreen({super.key, required this.isInSetting});

  @override
  State<ProfileAccountScreen> createState() => _ProfileAccountScreen();
}

class _ProfileAccountScreen extends State<ProfileAccountScreen> {
  late FocusNode firstNode;
  late FocusNode lastNode;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late ProfileAccountCubit cubit;
  late AppCubit appCubit;
  final regExp = RegExp(r'[^(a-zA-Z)+(\s)+(a-zA-Z)$]');
  late bool isChangeAvatar;

  @override
  void initState() {
    super.initState();
    firstNode = FocusNode();
    lastNode = FocusNode();
    cubit = BlocProvider.of<ProfileAccountCubit>(context);
    appCubit = BlocProvider.of<AppCubit>(context);
    isChangeAvatar = false;
    cubit.getData(appCubit.state.user!.phoneNumber!);
    lastNameController = TextEditingController();
    firstNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        firstNode.unfocus();
        lastNode.unfocus();
      },
      child: BlocBuilder<ProfileAccountCubit, ProfileAccountState>(
          bloc: cubit,
          builder: ((context, state) => Scaffold(
                  body: Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 47, left: 16, right: 16),
                  child: Row(
                    children: [
                      Visibility(
                          visible: widget.isInSetting,
                          replacement: const SizedBox(),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.navigate_before))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Your Profile',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 46),
                    height: 100,
                    width: 100,
                    child: Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: state.avatar == null
                              ? Image.asset('assets/images/Avatar.png',
                                  height: 100, width: 100, fit: BoxFit.cover)
                              : Image.network(state.avatar!,
                                  height: 100, width: 100, fit: BoxFit.cover)),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 68, left: 68, bottom: 1, right: 1),
                          child: IconButton(
                              icon: const Icon(Icons.add_circle, size: 24),
                              onPressed: () async {
                                ImageSource? source;
                                XFile? image;
                                String? croppedFile;
                                source = await chooseSource(context);
                                if (source != null) {
                                  image = await showImagePicker(source);
                                  if (image != null) {
                                    croppedFile =
                                        await cropImage(File(image.path));
                                    if (croppedFile != null) {
                                      cubit.changeAvatar(
                                          avatar: await uploadAvatar(
                                              appCubit.state.user!.phoneNumber!,
                                              croppedFile));
                                      isChangeAvatar = true;
                                    }
                                  }
                                }
                              }))
                    ])),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: boxColor),
                    margin: const EdgeInsets.only(top: 31, left: 24, right: 24),
                    child: TextField(
                        maxLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: firstNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          if (value.isEmpty) {
                            showStatusToast('Please enter your First Name!');
                            FocusScope.of(context).requestFocus(firstNode);
                          } else {
                            if (regExp.hasMatch(value)) {
                              showStatusToast(
                                  'Please do not use Number and Special character in this field!');
                              FocusScope.of(context).requestFocus(firstNode);
                            } else {
                              firstNameController.text = value;
                              FocusScope.of(context).requestFocus(lastNode);
                            }
                          }
                        },
                        controller: firstNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'First Name (Required)',
                            hintStyle: TextStyle(
                                color: disableTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)))),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: boxColor),
                    margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        focusNode: lastNode,
                        onSubmitted: (value) {
                          if (regExp.hasMatch(value)) {
                            showStatusToast(
                                'Please do not use Number and Special character in this field!');
                            FocusScope.of(context).requestFocus(lastNode);
                          } else {
                            lastNameController.text = value;
                          }
                        },
                        controller: lastNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Last Name (Optional)',
                            hintStyle: TextStyle(
                                color: disableTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)))),
                Container(
                  width: 327,
                  height: 52,
                  margin: const EdgeInsets.only(top: 68),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (firstNameController.text.isEmpty) {
                        showStatusToast(
                            'Please do not leave the required fields empty!');
                      } else {
                        if (regExp.hasMatch(firstNameController.text) ||
                            regExp.hasMatch(lastNameController.text)) {
                          showStatusToast(
                              'Please do not use Number and Special character in this field!');
                        } else {
                          if (widget.isInSetting == true) {
                            if (state.firstName != firstNameController.text) {
                              await DatabaseFunctions().updateUserProfile(
                                  'firstName',
                                  firstNameController.text,
                                  appCubit.state.user!.phoneNumber!);
                            }
                            if (state.lastName != lastNameController.text) {
                              await DatabaseFunctions().updateUserProfile(
                                  'lastName',
                                  lastNameController.text,
                                  appCubit.state.user!.phoneNumber!);
                            }
                            if (isChangeAvatar == true) {
                              await DatabaseFunctions().updateUserProfile(
                                  'avatarURL',
                                  state.avatar,
                                  appCubit.state.user!.phoneNumber!);
                            }
                            Future.delayed(
                                Duration.zero, () => Navigator.pop(context));
                          } else {
                            await DatabaseFunctions().addUserProfile(
                                firstNameController.text,
                                lastNameController.text,
                                state.avatar,
                                appCubit.state.user!.phoneNumber!);
                            Future.delayed(
                                Duration.zero,
                                () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(pageIndex: 0))));
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text('Save',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                )
              ])))),
    );
  }
}
