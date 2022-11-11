import 'package:chat_app/ui/verification/verification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../commons/app_commons.dart';

class VerificationScreen2 extends StatefulWidget {
  final String phoneCode;
  final String phoneNumber;
  final String verifyID;

  const VerificationScreen2(
      {super.key,
      required this.phoneCode,
      required this.phoneNumber,
      required this.verifyID});

  @override
  State<VerificationScreen2> createState() => _VerificationScreen2();
}

class _VerificationScreen2 extends State<VerificationScreen2> {
  String otpPin = '';
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SignInCubit>(context);
    return Scaffold(
        body: Column(children: [
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
          Text('Enter Code',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 24, color: textColor)),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
                'We have sent you an SMS with the code to +${widget.phoneCode} ${widget.phoneNumber}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor),
                textAlign: TextAlign.center),
          ),
          Container(
              margin: const EdgeInsets.only(top: 48),
              child: PinCodeTextField(
                autoFocus: true,
                appContext: context,
                length: 6,
                pastedTextStyle: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 32),
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                    activeFillColor: const Color.fromRGBO(237, 237, 237, 1),
                    inactiveColor: const Color.fromRGBO(237, 237, 237, 1),
                    disabledColor: const Color.fromRGBO(237, 237, 237, 1),
                    errorBorderColor: const Color.fromRGBO(237, 237, 237, 1),
                    inactiveFillColor: const Color.fromRGBO(237, 237, 237, 1),
                    selectedColor: const Color.fromRGBO(237, 237, 237, 1),
                    selectedFillColor: const Color.fromRGBO(237, 237, 237, 1),
                    borderWidth: 0,
                    shape: PinCodeFieldShape.circle,
                    fieldHeight: 40,
                    fieldWidth: 32,
                    activeColor: const Color.fromRGBO(237, 237, 237, 1)),
                onChanged: (String value) {
                  setState(() {
                    otpPin = value;
                  });
                },
                onCompleted: ((value) {
                  if (otpPin.length == 6) {
                    cubit.verifyOTP(context, widget.verifyID, otpPin);
                  }
                }),
              )),
          Container(
            margin: const EdgeInsets.only(top: 89),
            child: TextButton(
                onPressed: () {
                  cubit.verifyNumber(
                      context, widget.phoneCode, widget.phoneNumber);
                },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color.fromRGBO(0, 45, 227, 1)),
                )),
          )
        ]),
      )
    ]));
  }
}
