import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
    const RegisterPage({Key key}) : super(key: key);

    static const String routeName = '/register';

    @override
    _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Register'),
                centerTitle: true,
                elevation: 0.0,
            ),
            body: const SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: RegisterForm(),
                ),
            ),
        );
    }
}

class RegisterForm extends StatefulWidget {
    const RegisterForm({Key key}) : super(key: key);

    @override
    _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _agreedToTOS = true;

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Nickname',
                        ),
                        validator: (String value) {
                            if (value.trim().isEmpty) {
                                return 'Nickname is required';
                            }
                        },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Fullname',
                        ),
                        validator: (String value) {
                            if (value.trim().isEmpty) {
                                return 'Fullname is required';
                            }
                        },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                            children: <Widget>[
                                Checkbox(
                                    value: _agreedToTOS,
                                    onChanged: _setAgreedToTOS,
                                ),
                                GestureDetector(
                                    onTap: () => _setAgreedToTOS(!_agreedToTOS),
                                    child: const Text(
                                        'I agree to the Terms of Service and Privacy Policy.'
                                    ),
                                ),
                            ],
                        ),
                    ),
                    Row(
                        children: <Widget>[
                            const Spacer(),
                            OutlineButton(
                                highlightedBorderColor: Colors.black,
                                onPressed: _submittable() ? _submit : null,
                                child: const Text('Register'),
                            ),
                        ],
                    )
                ],
            )
        );
    }

    bool _submittable() {
        return _agreedToTOS;
    }

    void _submit() {
        _formKey.currentState.validate();
        print('Form Submitted!');
    }

    void _setAgreedToTOS(bool newValue) {
        setState(() {
            _agreedToTOS = newValue;
        });
    }
}