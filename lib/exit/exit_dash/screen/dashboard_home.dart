import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';
import 'package:ztsparking/exit/exit_dash/data/repository/scanner_repository.dart';
import 'package:ztsparking/exit/exit_dash/screen/scanned_ticket.dart';
import 'package:ztsparking/utils/methods.dart';

import '../../../main.dart';


class ExitDashboardScanScreen extends StatefulWidget {
  const ExitDashboardScanScreen({Key? key}) : super(key: key);

  @override
  _ExitDashboardScanScreenState createState() => _ExitDashboardScanScreenState();
}

class _ExitDashboardScanScreenState extends State<ExitDashboardScanScreen> {
  late bool loading = false;
  late String qrCode = "";

  List<String> scannedTickets = [];
  List<String> items = ["Parking",];
  String selectedItem = "";

  @override
  void initState() {
    selectedItem = items[0];
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    super.initState();
  }

  clear() {
    setState(() {
      qrCode = "";
    });
  }

  String selected = "return";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) async {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            scannedTickets.add(qrCode);

            qrCodeScan(context: context, qrCode1: cleanQr(qrCode.trim()), clear: clear);
          } else if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
            scannedTickets.add(qrCode);
            qrCodeScan(context: context, qrCode1: cleanQr(qrCode.trim()), clear: clear);
          } else {
            if (event.character != null) {
              setState(() {
                qrCode = qrCode + event.character!;
              });
            }
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 2),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      value: selectedItem,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(value: items, child: Text(items));
                      }).toList(),
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: appFonts.ubuntu
                      ),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItem = newValue ?? items[0];
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: "Logout",
                          icon: Icon(Icons.camera),
                          onPressed: () {
                            FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR)
                                .then((value) {
                              qrCodeScan(
                                  context: context, qrCode1: cleanQr(value.trim()), clear: clear);
                            });
                          },
                        ),
                        IconButton(
                          tooltip: "Logout",
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            sharedPref.setLoggedOut();

                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              Center(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        shadowColor: Colors.redAccent,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          width: 350,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Scan Ticket",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   _textNode.requestFocus();
                                    // });
                                  },
                                  child: Lottie.asset('assets/lottie/scan-barcode.json',
                                      width: 280, fit: BoxFit.cover),
                                ),
                                const Text(
                                  'Scan QR Code',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  qrCode,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shadowColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.pressed))
                                            return Colors.white;
                                          return Colors.white; // Use the component's default.
                                        },
                                      ),
                                      elevation: MaterialStateProperty.resolveWith<double>(
                                          (Set<MaterialState> states) {
                                        return 10;
                                      }),
                                    ),
                                    onPressed: () async {
                                      qrCodeScan(context: context, qrCode1: qrCode, clear: clear);
                                    },
                                    child: loading
                                        ? Container(
                                            height: 45,
                                            width: 24,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ))
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                                Text(
                                                  'Scan Ticket',
                                                  style: TextStyle(
                                                      fontSize: 18, fontWeight: FontWeight.w600),
                                                ),
                                              ]),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void qrCodeScan(
      {required BuildContext context, required String qrCode1, required Function clear}) async {
    setState(() {
      loading = true;
    });
    ScannerRepository().scanTicket(context: context, ticketNumber: qrCode1).then((value) {
      if (value != null) {
        //TODO : Dialog box
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PostTicketScanScreen(
              ticketDetail: value,
            ),
          ),
        ).then((value) {
          loading = false;
          clear();
        });
      } else {
        setState(() {
          loading = false;
          clear();
        });
      }
    });
  }

  void handleKey(RawKeyEventData data) {
    setState(() {});
  }
}
