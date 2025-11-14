import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Welcome Back!' : 'Join Nobokormo'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLogin
                ? LoginForm(
              key: const ValueKey('login'),
              onToggle: () => setState(() => isLogin = false),
            )
                : RegisterForm(
              key: const ValueKey('register'),
              onToggle: () => setState(() => isLogin = true),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final VoidCallback onToggle;
  const LoginForm({super.key, required this.onToggle});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(_email, _password);
      if (!success && authProvider.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Sign In', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!,
            validator: (value) => value!.isEmpty || !value.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value!,
            validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 25),
          authProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _submit,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: widget.onToggle,
            child: const Text('Don\'t have an account? Register'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final VoidCallback onToggle;
  const RegisterForm({super.key, required this.onToggle});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(_fullName, _email, _password);

      if (!success && authProvider.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Full Name'),
            onSaved: (value) => _fullName = value!,
            validator: (value) => value!.isEmpty ? 'Enter your full name' : null,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!,
            validator: (value) => value!.isEmpty || !value.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password (min 6 chars)'),
            obscureText: true,
            onSaved: (value) => _password = value!,
            validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 25),
          authProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _submit,
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: widget.onToggle,
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}