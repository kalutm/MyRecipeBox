import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/utils/constants/route_constants.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  bool _canResendEmail = false;
  Timer? _resendTimer;
  int _remainingSeconds = 30;

  void _sendEmailVerification() async {
    await AuthService.fireAuth().sendVerificationEmail();
    setState(() {
      _canResendEmail = false;
      _remainingSeconds = 30; // Reset the timer
    });
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResendEmail = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    _sendEmailVerification();
    super.initState();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: emailVerificatoinTextWidget),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 60.0, color: Colors.grey),
              const SizedBox(height: 24.0),
              Text(
                'Please verify your email address.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              verificationEmailHaveBeenSentTextWidget,
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _canResendEmail ? _sendEmailVerification : null,
                child: Text(
                  _canResendEmail
                      ? sendVerificatoinAgainTextWidget.data!
                      : 'Resend Email (${_remainingSeconds}s)', // Use the local variable
                ),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(loginViewRoute);
                },
                child: const Text('Already verified? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
