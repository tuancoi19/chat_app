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
  FocusNode firstNode = FocusNode();
  FocusNode lastNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  late ProfileAccountCubit cubit;
  late AppCubit appCubit;
  final regExp = RegExp(r'[^(a-zA-Z)+(\s)+(a-zA-Z)$]');
  late bool isChangeAvatar;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ProfileAccountCubit>(context);
    appCubit = BlocProvider.of<AppCubit>(context);
    cubit.getData(appCubit.state.userNumber!);
    isChangeAvatar = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileAccountCubit, ProfileAccountState>(
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
                              color: text_color,
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
                    state.avatar == null
                        ? ClipOval(
                            child: Image.asset('assets/images/Avatar.png',
                                height: 100, width: 100, fit: BoxFit.cover))
                        : ClipOval(
                            child: Image.network(state.avatar!,
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
                                            appCubit.state.userNumber!,
                                            croppedFile));
                                    isChangeAvatar = true;
                                  }
                                }
                              }
                            }))
                  ])),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4), color: box_color),
                  margin: const EdgeInsets.only(top: 31, left: 24, right: 24),
                  child: TextField(
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
                            FocusScope.of(context).requestFocus(lastNode);
                          }
                        }
                      },
                      controller: firstNameController
                        ..text = state.firstName ?? '',
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name (Required)',
                          hintStyle: TextStyle(
                              color: disable_text_color,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)))),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4), color: box_color),
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
                        }
                      },
                      controller: lastNameController
                        ..text = state.lastName ?? '',
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last Name (Optional)',
                          hintStyle: TextStyle(
                              color: disable_text_color,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)))),
              Container(
                width: 327,
                height: 52,
                margin: const EdgeInsets.only(top: 68),
                child: ElevatedButton(
                  onPressed: () {
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
                            DatabaseFunctions().updateUserProfile(
                                'firstName',
                                firstNameController.text,
                                appCubit.state.userNumber!);
                          }
                          if (state.lastName != lastNameController.text) {
                            DatabaseFunctions().updateUserProfile(
                                'lastName',
                                lastNameController.text,
                                appCubit.state.userNumber!);
                          }
                          if (isChangeAvatar == true) {
                            DatabaseFunctions().updateUserProfile('avatarURL',
                                state.avatar, appCubit.state.userNumber!);
                          }
                          Navigator.pop(context);
                        } else {
                          DatabaseFunctions().addUserProfile(
                              firstNameController.text,
                              lastNameController.text,
                              state.avatar,
                              appCubit.state.userNumber!);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScreen(pageIndex: 0)));
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Save',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              )
            ]))));
  }
}
