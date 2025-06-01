import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AuthService.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isCelebrity = false;
  final _authService = AuthService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        Fluttertoast.showToast(
          msg: "Passwords don't match",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final result = await _authService.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );

        if (result['success']) {
          if (!mounted) return;
          Fluttertoast.showToast(
            msg: "Registration successful! Please login.",
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          if (!mounted) return;
          final errorMsg = result['message'] ?? "Registration failed.";
          Fluttertoast.showToast(
            msg: errorMsg,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } catch (e) {
        if (!mounted) return;
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again later.",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[600],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: MediaQuery.of(context).size.height - 40,
              ),
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 50),
                    _buildSignUpText(),
                    const SizedBox(height: 30),
                    _buildForm(),
                    const SizedBox(height: 30),
                    _buildRegisterButton(),
                    const SizedBox(height: 20),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('lib/images/img.png'),
        ),
        const SizedBox(width: 10),
        Text(
          'CELEBRATING',
          style: GoogleFonts.lato(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign up',
          style: GoogleFonts.andika(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Text(
              'Already have an account? ',
              style: GoogleFonts.andika(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Text(
                'Sign In',
                style: GoogleFonts.andika(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm() {
    const inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );

    const errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    );

    const textStyle = TextStyle(color: Colors.white);
    const labelStyle = TextStyle(color: Colors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            labelStyle: labelStyle,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
          style: textStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
            }
            if (value.length < 3) {
              return 'Username must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: labelStyle,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
          style: textStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: labelStyle,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
          style: textStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: labelStyle,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
          style: textStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text(
            'Register as Celebrity',
            style: GoogleFonts.andika(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: _isCelebrity,
          onChanged: (bool value) {
            setState(() {
              _isCelebrity = value;
            });
          },
          activeColor: Colors.white,
          inactiveTrackColor: Colors.white.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              'Register',
              style: GoogleFonts.andika(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber[600],
              ),
            ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: Text(
        'Already have an account? Sign In',
        style: GoogleFonts.andika(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
