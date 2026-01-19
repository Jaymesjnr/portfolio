import 'package:flutter/material.dart';
import 'package:jnrapp/screens/home.dart';
import 'package:provider/provider.dart';

// If AppState is not defined, add the following minimal definition as a placeholder:
class AppState with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool loading = false;
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future<void> _authenticate() async {
  if (!_formKey.currentState!.validate()) return;
  _formKey.currentState!.save();
  setState(() => loading = true);

  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));

  // Fake success
  if (!mounted) return;
  context.read<AppState>().setToken('mock-token');
  setState(() => loading = false);

  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
        
          Container(color: Colors.black.withOpacity(0.6)), // overlay

          Center(
            child: SingleChildScrollView(
              child: Container(
                width: size.width * 0.9,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/assets/splash.png', height: 40),
                    SizedBox(height: 16),
                    Text(
                      isLogin ? 'Welcome Back' : 'Create Account',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      isLogin
                          ? 'Login to continue'
                          : 'Sign up to get started',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email, color: Colors.white70),
                              labelStyle: TextStyle(color: Colors.white70),
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Enter email' : null,
                            onSaved: (v) => email = v!,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            obscureText: obscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () =>
                                    setState(() => obscure = !obscure),
                              ),
                              labelStyle: TextStyle(color: Colors.white70),
                            ),
                            validator: (v) =>
                                v != null && v.length < 6 ? 'Min 6 chars' : null,
                            onSaved: (v) => password = v!,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: loading ? null : _authenticate,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: loading
                                ? CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2)
                                : Text(isLogin ? 'Login' : 'Sign Up'),
                          ),
                          SizedBox(height: 12),
                          TextButton(
                            onPressed: () =>
                                setState(() => isLogin = !isLogin),
                            child: Text(
                              isLogin
                                  ? 'Don’t have an account? Sign up'
                                  : 'Already have an account? Login',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
