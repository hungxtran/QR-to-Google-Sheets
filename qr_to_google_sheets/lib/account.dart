import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Function to show the alert dialog
    Future<void> _showSignInDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'QrToGoogleSheets Wants to Use "google.com" to Sign In.'),
            content: const Text(
                'This allows the app and website to share information about you.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Continue'),
                onPressed: () async {
                  // Define the URL for Google Sheets permissions (replace with your actual URL)
                  final Uri googleSheetsPermissionUrl = Uri(
                      scheme: 'https',
                      host: 'www.googleapis.com',
                      path: '/auth/spreadsheets');

                  if (await canLaunchUrl(googleSheetsPermissionUrl)) {
                    await launchUrl(googleSheetsPermissionUrl);
                  } else {
                    // Handle the error if the URL cannot be launched
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to open the URL.'),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                onPressed:
                    _showSignInDialog, // Show the dialog when the button is tapped
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
            ),
            const SizedBox(
                height:
                    16), // Add spacing between the button and the description
            Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please sign in with a Google account to use',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Google Sheets (Drive)',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Add additional content for the AccountPage here
          ],
        ),
      ),
    );
  }
}
