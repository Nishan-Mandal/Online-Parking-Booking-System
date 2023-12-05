import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:online_parking/utils/Authentication.dart';
import 'package:online_parking/utils/CommonWidgets.dart';
import 'Parking Provider/AdminDashboard.dart';
import 'End User/UserDashbord.dart';

class LoginPage extends StatefulWidget {
  final bool isUser;

  // Constructor with parameter
  const LoginPage({Key? key, required this.isUser}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Authentication authObj = Authentication();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  bool _highlightFields = false;
  CommonWidgets cw = CommonWidgets();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              _buildFullNameTextField(),
              SizedBox(height: 10.0),
              _buildPhoneNumberTextField(),
              SizedBox(height: 20.0),
              _buildLoginButton(context),
              SizedBox(height: 20.0),
              _buildGoogleLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameTextField() {
    return TextFormField(
      controller: _fullNameController,
      focusNode: _fullNameFocus,
      decoration: InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(),
        errorText: _highlightFields && _fullNameController.text.isEmpty
            ? 'Enter your full name'
            : null,
      ),
    );
  }

  Widget _buildPhoneNumberTextField() {
    return TextFormField(
      controller: _phoneNumberController,
      focusNode: _phoneNumberFocus,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
        errorText: _highlightFields && _phoneNumberController.text.isEmpty
            ? 'Enter your phone number'
            : null,
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _highlightFields = true;
        });
        _validateAndSubmit(context);
      },
      icon: Icon(Icons.login_outlined),
      label: Text('Login with mobile'),
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await authObj.signInWithGoogle();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  widget.isUser ? UserDashboard() : AdminDashboard()),
        );
        cw.addUser('','');
      },
      icon: Icon(Icons.login_outlined),
      label: Text('Login with Google'),
    );
  }

  void _validateAndSubmit(BuildContext context) {
    final fullName = _fullNameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

    if (fullName.isEmpty || phoneNumber.isEmpty) {
      // Highlight the fields with validation error
      if (fullName.isEmpty) {
        _fullNameFocus.requestFocus();
      }
      if (phoneNumber.isEmpty) {
        _phoneNumberFocus.requestFocus();
      }
    } else {
      authObj.verifyPhoneNumber(_phoneNumberController.text);
      _showOtpDialog(context);
    }
  }

  void _showOtpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  await authObj.signInWithPhoneNumber(_otpController.text);
                  _otpController.clear();
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.isUser
                            ? UserDashboard()
                            : AdminDashboard()),
                  );
                  cw.addUser(_fullNameController.text,_phoneNumberController.text);
                },
                child: Text('Verify OTP'),
              ),
            ],
          ),
        );
      },
    );
  }

}
