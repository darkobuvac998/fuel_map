import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../widgets/custom_card.dart';

enum AuthMode { signup, signin }

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _mode = AuthMode.signin;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();
  var _isLoading = false;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  late AnimationController _controller;
  late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
      begin: Size(
        double.infinity,
        screenHeight * 0.3,
      ),
      end: Size(
        double.infinity,
        screenHeight * 0.4,
      ),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween(
            begin: const Offset(
              0.0,
              -0.8,
            ),
            end: const Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    super.initState();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_mode == AuthMode.signin) {
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData['email'] ?? '',
          _authData['password'] ?? '',
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'] ?? '',
          _authData['password'] ?? '',
        );
      }
    } on HttpException catch (error) {
      var errorMsg = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMsg = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMsg = 'This is not valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMsg = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMsg = 'Could not found a user with the email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMsg = 'Invalid password';
      }
      _showErrorDialog(errorMsg);
    } catch (error) {
      print(error);
      const errorMsg = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMsg);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'OK',
              ),
            )
          ],
          title: const Text(
            'An Error Occurred!',
          ),
          content: Text(msg),
        );
      },
    );
  }

  void _onModeChange() {
    setState(() {
      if (_mode == AuthMode.signin) {
        _mode = AuthMode.signup;
        _controller.forward();
      } else {
        _mode = AuthMode.signin;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: deviceSize.width * 0.2,
              vertical: 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: deviceSize.height * 0.05,
                ),
                FittedBox(
                  child: Image.asset(
                    'assets/images/login_image.jpeg',
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.scaleDown,
                ),
                CustomCard(
                  child: SizedBox(
                    width: deviceSize.width * 0.5,
                    height: deviceSize.height * 0.05,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Fuel map',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.05,
                ),
                _mode == AuthMode.signin
                    ? Text(
                        'Login',
                        style: Theme.of(context).textTheme.headline5,
                      )
                    : Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
                if (_mode == AuthMode.signin)
                  Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  )
                else
                  Text(
                    'Please sign up to continue',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
                AnimatedBuilder(
                  animation: _heightAnimation,
                  builder: (ctx, child) => Container(
                      // height: (deviceSize.height -
                      //         MediaQuery.of(context).viewInsets.bottom) *
                      //     0.25,
                      height: _heightAnimation.value.height,
                      padding: const EdgeInsets.all(
                        2,
                      ),
                      child: child),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'E-Mail',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null &&
                                  (value.isEmpty || !value.contains('@'))) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value != null &&
                                  (value.isEmpty || value.length < 5)) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value ?? '';
                            },
                          ),
                          if (_mode == AuthMode.signup)
                            FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: TextFormField(
                                  enabled: _mode == AuthMode.signup,
                                  decoration: const InputDecoration(
                                      labelText: 'Confirm Password'),
                                  obscureText: true,
                                  validator: _mode == AuthMode.signup
                                      ? (value) {
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: deviceSize.height * 0.01,
                          ),
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _submit,
                                  child: Row(
                                    children: [
                                      _mode == AuthMode.signin
                                          ? const Text(
                                              'LOGIN',
                                            )
                                          : const Text(
                                              'SING UP',
                                            ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_outlined,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
                _mode == AuthMode.signin
                    ? Row(
                        children: [
                          const Text(
                            'Dont\' have an account?',
                          ),
                          TextButton(
                            onPressed: _onModeChange,
                            child: const Text(
                              'Sign up',
                            ),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          const Text(
                            'Already have a account?',
                          ),
                          TextButton(
                            onPressed: _onModeChange,
                            child: const Text(
                              'Sign in',
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// AnimatedController
