import 'package:flutter/material.dart';
import 'package:thoughts/core/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(Icons.person, size: 100),
              ),
              SizedBox(height: 16),
              Text(
                "Guest",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          "You are not logged in. Please log in to continue.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: Text("Log in"),
        ),
      ],
    );
  }
}
