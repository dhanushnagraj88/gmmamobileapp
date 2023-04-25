import 'package:flutter/material.dart';

class CustomerAuthForm extends StatefulWidget {
  const CustomerAuthForm({
    Key? key,
    required this.isLoading,
    required this.submitFn,
  }) : super(key: key);

  final bool isLoading;
  final void Function({
    required String userName,
    required int phone,
    required String email,
    required String password,
    required bool isLogin,
    required BuildContext ctx,
  }) submitFn;

  @override
  State<CustomerAuthForm> createState() => _CustomerAuthFormState();
}

class _CustomerAuthFormState extends State<CustomerAuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName = '';
  var _userPhone = 0;
  var _userEmail = '';
  var _userPassword = '';
  // var _userConfirm = '';
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        ctx: context,
        email: _userEmail.trim(),
        userName: _userName.trim(),
        phone: _userPhone,
        isLogin: _isLogin,
        password: _userPassword,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Please enter at least 5 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('number'),
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || value.length != 10) {
                          return 'Enter a valid Phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPhone = int.parse(value!);
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Enter a password of at least 7 characters';
                      }
                      return null;
                    },
                    controller: passwordController,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('confirm'),
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      // onSaved: (value) {
                      //   _userConfirm = value!;
                      // },
                      controller: confirmPasswordController,
                      validator: (_) {
                        if (confirmPasswordController.text !=
                            passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () => setState(() {
                        _isLogin = !_isLogin;
                      }),
                      child: Text(_isLogin
                          ? 'Don\'t have an account? Signup'
                          : 'Already have an account? Login'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
