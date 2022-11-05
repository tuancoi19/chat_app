import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/commons/app_commons.dart';
import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/ui/home/contacts/contacts_cubit.dart';
import 'package:chat_app/ui/home/contacts/contacts_state.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../models/entities/rooms.dart';
import '../../../models/entities/users.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContactsScreen();
}

class _ContactsScreen extends State<ContactsScreen> {
  late ContactsCubit _cubit;
  late AppCubit appCubit;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    appCubit = BlocProvider.of<AppCubit>(context);
    _cubit = BlocProvider.of<ContactsCubit>(context);
    _cubit.getContacts(appCubit.state.userNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
        bloc: _cubit,
        builder: (BuildContext context, state) {
          return Scaffold(
              body: Container(
                  margin: const EdgeInsets.only(top: 47),
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Contacts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: text_color)),
                              IconButton(
                                  icon: Icon(Icons.add, color: text_color),
                                  onPressed: null)
                            ])),
                    Container(
                        margin: const EdgeInsets.only(top: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: box_color),
                        child: TextField(
                          controller: controller,
                          onChanged: (value) async {
                            List<UserChat>? listSearch =
                                await DatabaseFunctions()
                                    .getAllUser(appCubit.state.userNumber!);
                            List<UserChat> listResult;
                            if (value.isEmpty) {
                              _cubit.getContacts(appCubit.state.userNumber!);
                              listResult = state.listContacts;
                            } else {
                              if (value[0] == '+') {
                                listResult = listSearch!
                                    .where((element) =>
                                        element.phoneNumber.contains(value))
                                    .toList();
                              } else {
                                listResult = listSearch!
                                    .where((element) =>
                                        ('${element.name.firstName} ${element.name.lastName}')
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();
                              }
                            }
                            _cubit.changeListContacts(listContacts: listResult);
                          },
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.search, color: disable_text_color),
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  color: disable_text_color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return itemContact(state.listContacts[index]);
                        },
                        itemCount: state.listContacts.length,
                      ),
                    )
                  ])));
        });
  }

  Widget itemContact(UserChat? item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => PersonalChatCubit(),
                      child: PersonalChatScreen(guest: item),
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: disable_text_color))),
        width: 327,
        height: 68,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Stack(children: [
              Container(
                width: 56,
                height: 56,
                decoration: item!.storyURL!.isNotEmpty
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: const GradientBoxBorder(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(210, 213, 249, 1),
                                  Color.fromRGBO(44, 55, 225, 1)
                                ]),
                            width: 2))
                    : null,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: box_color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: item.avatarURL!.isEmpty
                        ? Image.asset('assets/images/Avatar.png',
                            fit: BoxFit.contain)
                        : Image.network(item.avatarURL!, fit: BoxFit.contain),
                  )),
                ),
              ),
              item.isActive == true
                  ? Container(
                      height: 14,
                      width: 14,
                      margin: const EdgeInsets.only(
                          top: 2, left: 38, right: 2, bottom: 38),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(90),
                          color: const Color.fromRGBO(44, 192, 105, 1)),
                    )
                  : const SizedBox()
            ]),
            const SizedBox(width: 12),
            SizedBox(
              height: 56,
              width: 259,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('${item.name.firstName} ${item.name.lastName}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: text_color)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.isActive == true ? 'Online' : 'Offline',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: disable_text_color),
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
