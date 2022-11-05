import 'package:chat_app/ui/verification/verification_cubit.dart';
import 'package:chat_app/ui/verification/verification_state.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../commons/app_commons.dart';
import '../../functions/show_toast.dart';

class VerificationScreen1 extends StatefulWidget {
  const VerificationScreen1({super.key});

  @override
  State<VerificationScreen1> createState() => _VerificationScreen1();
}

class _VerificationScreen1 extends State<VerificationScreen1> {
  Country selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('VN');

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SignInCubit>(context);
    return BlocBuilder<SignInCubit, SignInState>(
      bloc: cubit,
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 52.99, right: 343.29),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.navigate_before)),
            ),
            Container(
              width: 295,
              margin: const EdgeInsets.only(top: 103.99),
              child: Column(children: [
                Text('Enter Your Phone Number',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: text_color)),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Text(
                      'Please confirm your country code and enter your phone number',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: text_color),
                      textAlign: TextAlign.center),
                )
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 48, left: 24, right: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _openCountryPickerDialog(context);
                    },
                    child: Container(
                        width: 97,
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: box_color),
                        child: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Center(
                                      child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                        CountryPickerUtils.getDefaultFlagImage(
                                            selectedDialogCountry),
                                  )),
                                ),
                                const SizedBox(width: 8),
                                Text('+${selectedDialogCountry.phoneCode}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: disable_text_color))
                              ],
                            ))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: box_color),
                          child: TextField(
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone number',
                                hintStyle: TextStyle(
                                    color: disable_text_color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                showStatusToast(
                                    'This field must not be empty!');
                              } else {
                                var cubit =
                                    BlocProvider.of<SignInCubit>(context);
                                cubit.changePhoneNumber(phoneNumber: value);
                              }
                            },
                          )))
                ],
              ),
            ),
            Container(
              width: 327,
              height: 52,
              margin: const EdgeInsets.only(top: 81),
              child: ElevatedButton(
                onPressed: () async {
                  if (state.phoneNumber == null) {
                    showStatusToast('Please enter your number!');
                  } else {
                    cubit.verifyNumber(
                        context, state.phoneCode, state.phoneNumber!);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: button_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: const Text('Continue',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openCountryPickerDialog(BuildContext context) {
    var cubit = BlocProvider.of<SignInCubit>(this.context);
    showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select your phone code'),
            onValuePicked: (Country country) {
              setState(() => selectedDialogCountry = country);
              cubit.changePhoneCode(phoneCode: country.phoneCode);
            },
            itemBuilder: _buildDialogItem));
  }
}

Widget _buildDialogItem(Country country) => Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
