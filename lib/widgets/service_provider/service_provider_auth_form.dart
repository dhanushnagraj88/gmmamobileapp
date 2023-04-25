import 'package:flutter/material.dart';

class ServiceProviderAuthForm extends StatefulWidget {
  const ServiceProviderAuthForm({
    Key? key,
    required this.isLoading,
    required this.submitFn,
  }) : super(key: key);

  final bool isLoading;
  final void Function({
    required int phone,
    required String email,
    required String password,
    required bool isLogin,
    required BuildContext ctx,
  }) submitFn;

  @override
  State<ServiceProviderAuthForm> createState() =>
      _ServiceProviderAuthFormState();
}

class _ServiceProviderAuthFormState extends State<ServiceProviderAuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userPhone = 0;
  var _userEmail = '';
  var _userPassword = '';
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        ctx: context,
        phone: _userPhone,
        email: _userEmail.trim(),
        password: _userPassword.trim(),
        isLogin: _isLogin,
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
                      keyboardType: TextInputType.phone,
                      key: const ValueKey('phoneNumber'),
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length != 10) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPhone = int.parse(value!);
                      },
                    ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Please enter a minimum of 7 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('confirmPassword'),
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          return 'Passwords don\'t match!';
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
