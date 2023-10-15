import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'GOOGLE ACCOUNT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8), // Add some spacing
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'A Google sign-in is required for Google Sheets (Drive) connection.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
                height:
                    16), // Add spacing between the description and the button
            Center(
              child: TextButton(
                onPressed: () {
                  // Add your Google sign-in logic here
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                ),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ), // Add additional content for the AccountPage here
          ],
        ),
      ),
    );
  }
}
