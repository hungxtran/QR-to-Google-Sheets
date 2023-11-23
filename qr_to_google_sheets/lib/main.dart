import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter/cupertino.dart';

// your google auth credentials
// these can be obtain from: https://console.cloud.google.com/apis/dashboard
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "YOUR_PROJECT_ID",
  "private_key_id": "YOUR_PRIVATE_KEY_ID",
  "private_key": "YOUR_PRIVATE_KEY",
  "client_email": "YOUR_SERVICE_ACCOUNT_CLIENT_EMAIL",
  "client_id": "YOUR_CLIENT_ID",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "YOUR_CLIENT_X509_CERT_URL",
  "universe_domain": "googleapis.com"
}
''';

// your spreadsheet id.
// https://docs.google.com/spreadsheets/d/SPREADSHEET_ID_IS_HERE
const _spreadsheetId = 'YOUR_SPREADSHEET_ID';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = 'Tap  to scan';
  late TextEditingController _controller;
  int _selectedWorksheetIndex = 0;
  String _selectedWorksheetName = '';

  // Function to be executed when the "Import" button is pressed
  Future<void> importToSheets(String data) async {
    // Add your logic to import data to Google Sheets using the provided name
    debugPrint('Importing to Sheets with name: $data');
    // You can implement the actual logic for importing to Sheets here
    final currentSheet = await getCurrentSheet();
    // appends passed values to the products table
    await currentSheet.values.appendRow(
      [data],
    );
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 256,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: Column(
          children: [
            SizedBox(height: 190, child: child),
            // Close the modal
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  // Function to be executed when the "Import" button is pressed
  Future<void> selectWorksheet() async {
    // debugPrint('Implement select worksheet');
    final workingSheets = await getWorkingSheets();
    _showDialog(
      CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        // This sets the initial item.
        scrollController: FixedExtentScrollController(
          initialItem: _selectedWorksheetIndex,
        ),
        // This is called when selected item is changed.
        onSelectedItemChanged: (int selectedItem) {
          setState(() {
            _selectedWorksheetIndex = selectedItem;
            _selectedWorksheetName =
                workingSheets.elementAt(selectedItem).title;
          });
        },
        children: List<Widget>.generate(workingSheets.length, (int index) {
          return Center(child: Text(workingSheets.elementAt(index).title));
        }),
      ),
    );
  }

  Future<List<Worksheet>> getWorkingSheets() async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    final worksheets =
        ss.sheets.where((element) => element.title.contains("Line")).toList();
    return worksheets;
  }

  Future<Worksheet> getCurrentSheet() async {
    final worksheets = await getWorkingSheets();
    final currentSheet = worksheets.elementAt(_selectedWorksheetIndex);
    setState(() {
      _selectedWorksheetName = currentSheet.title;
    });
    return currentSheet;
  }

  @override
  void initState() {
    getCurrentSheet().then((currentSheet) {
      setState(() {
        _selectedWorksheetName = currentSheet.title;
      });
    });
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedWorksheetName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height: 16), // Add spacing between TextField and button
            // Button to trigger the import function
            ElevatedButton(
              // Display a CupertinoPicker with list of worksheets.
              onPressed: () async {
                // Call the importToSheets function with the TextField value
                await selectWorksheet();
              },
              child: const Text('Select worksheet'),
            ),
            const SizedBox(
                height:
                    150), // Add spacing between button and the rest of the content

            ElevatedButton(
              child: const Text('Scan Barcode'),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AiBarcodeScanner(
                      validator: (value) {
                        return value.isNotEmpty;
                      },
                      canPop: true,
                      onScan: (String value) async {
                        debugPrint(value);
                        await importToSheets(value);
                        setState(() {
                          barcode = value;
                        });
                      },
                      onDetect: (p0) {},
                      onDispose: () {
                        debugPrint("Barcode scanner disposed!");
                      },
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                    ),
                  ),
                );
              },
            ),
            Text(barcode),
          ],
        ),
      ),
    );
  }
}
