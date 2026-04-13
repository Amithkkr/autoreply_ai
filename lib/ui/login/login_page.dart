import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'login_store.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginStore _loginStore = LoginStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Structure Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Basic Project Structure (No Design System)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Observer(
                builder: (_) {
                  if (_loginStore.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  
                  return ElevatedButton(
                    onPressed: () {
                      // Example login with dummy credentials
                      _loginStore.login('test@example.com', 'password123');
                    },
                    child: const Text('Login API Call Example'),
                  );
                },
              ),
              const SizedBox(height: 20),
              Observer(
                builder: (_) {
                  if (_loginStore.userData != null) {
                    return Text(
                      'Logged in as: ${_loginStore.userData!.firstName} ${_loginStore.userData!.lastName}',
                      style: const TextStyle(color: Colors.green),
                    );
                  }
                  
                  if (_loginStore.errorMessage != null) {
                    return Text(
                      'Error: ${_loginStore.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
