import 'package:dicternclock/data/services/auth_service.dart';
import 'package:dicternclock/data/services/shared_preference.dart';
import 'package:dicternclock/utils/screen_util.dart';
import 'package:dicternclock/widgets/buttons/custom_button.dart';
import 'package:dicternclock/widgets/image/custom_image_display.dart';
import 'package:dicternclock/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false; // Add this

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _loadSavedCredentials() async {
    final savedCredentials = await PreferenceService.retrieveSavedCredentials();
    if (mounted) {
      setState(() {
        _usernameController.text = savedCredentials['username'] ?? '';
        _passwordController.text = savedCredentials['password'] ?? '';
        _isChecked = _usernameController.text.isNotEmpty; // Check "Remember Me" if credentials exist
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await AuthService().signIn(
      username: _usernameController.text,
      password: _passwordController.text,
      context: context,
      isChecked: _isChecked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtil.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFF0841B4),
            ],
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Center(
                            child: CustomImageDisplay(
                              imageSource: "lib/assets/images/logo.png",
                              imageHeight: screen.height * 0.35,
                              imageWidth: screen.width * 0.45,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 8),

                                _EmailTextField(
                                  controller: _usernameController,
                                  currentFocusNode: _usernameFocusNode,
                                  nextFocusNode: _passwordFocusNode,
                                ),

                                const SizedBox(height: 12),

                                _PasswordTextField(
                                  controller: _passwordController,
                                  currentFocusNode: _passwordFocusNode,
                                  nextFocusNode: null,
                                ),

                                const SizedBox(height: 5),

                                // Remember Me Checkbox
                                _RememberMeCheckbox(
                                  isChecked: _isChecked,
                                  onChanged: (newValue) {
                                    if (mounted) {
                                      setState(() {
                                        _isChecked = newValue!;
                                        if (!_isChecked) {
                                          PreferenceService.saveCredentials('', '');
                                        }
                                      });
                                    }
                                  },
                                ),

                                const SizedBox(height: 18),

                                _LoginButton(onPressed: _login),

                                SizedBox(
                                  height:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Powered by",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "DICT Caraga - ADS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "v1.0.0",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Private Email Text Field Widget
class _EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentFocusNode;
  final FocusNode nextFocusNode;

  const _EmailTextField({
    required this.controller,
    required this.currentFocusNode,
    required this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07),
      child: CustomTextField(
        controller: controller,
        currentFocusNode: currentFocusNode,
        nextFocusNode: nextFocusNode,
        inputFormatters: null,
        validator: (value) {
          if (value!.isEmpty) {
            return "Username is required";
          }
          return null;
        },
        isPassword: false,
        hintText: "Username",
        minLines: 1,
        maxLines: 1,
        prefixIcon: const Icon(Icons.email_rounded),
      ),
    );
  }
}

// Private Password Text Field Widget
class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;

  const _PasswordTextField({
    required this.controller,
    required this.currentFocusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07),
      child: CustomTextField(
        controller: controller,
        currentFocusNode: currentFocusNode,
        nextFocusNode: nextFocusNode,
        inputFormatters: null,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password is required";
          }
          return null;
        },
        isPassword: true,
        hintText: "Password",
        minLines: 1,
        maxLines: 1,
        prefixIcon: const Icon(Icons.lock_rounded),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07),
      child: CustomButton(
        buttonLabel: "Sign In",
        onPressed: onPressed,
        buttonHeight: 55.0,
        fontWeight: FontWeight.bold,
        fontSize: 15,
        fontColor: Colors.white,
        borderRadius: 10,
        gradientColors: const [
          Color(0xFF1E1E1F),
          Color(0xFF1E1E1F),
        ], // Blue gradient
      ),
    );
  }
}

class _RememberMeCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const _RememberMeCheckbox({
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07),
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: const Color(0xFF013dd6),
            ),
          ),
          const Text(
            "Remember me",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

