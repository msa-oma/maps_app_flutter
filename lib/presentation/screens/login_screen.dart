import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import '../../constnats/my_colors.dart';
import '../../constnats/strings.dart';
import '../widgets/next_button.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();
  late String phoneNumber;

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("what is your phone number?",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: const Text(
            'please enter your Phone Number to verify your account',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        )
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.lightGrey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Text(
              '${generateCountryFlage()} +963',
              style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.blue,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
              decoration: const InputDecoration(border: InputBorder.none),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Pleas enter your phone number !';
                } else if (value.length < 9) {
                  return 'number too short !';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlage() {
    String countryCode = 'sy';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

    return flag;
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _register(context);
        },
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(110, 50),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmitedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(otpScreen, arguments: phoneNumber);
        }
        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMsg = state.errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
          ));
        }
      },
      child: Container(),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _phoneFormKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(children: [
                _buildIntroText(),
                const SizedBox(
                  height: 50,
                ),
                _buildPhoneFormField(),
                const SizedBox(
                  height: 60,
                ),
                //    _buildNextButton(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NextButton(
                      onPressd: () {
                        showProgressIndicator(context);
                        _register(context);
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(mapScreen);
                        },
                        child: const Text(
                          'skip',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),

                ///see if this widget do its function as expected

                // TextButton(
                //     onPressed: () {
                //       Navigator.of(context).pushReplacementNamed(mapScreen);
                //     },
                //     child: const Text(
                //       'skip',
                //       style:
                //           TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                //     )),
                _buildPhoneNumberSubmitedBloc(),
              ]),
            )),
      ),
    );
  }
}
