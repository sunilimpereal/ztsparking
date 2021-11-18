// import 'dart:developer';

// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';
// import 'package:flutter/material.dart';
// import 'package:zts_parking/dashboard/widgets/drawer_widget.dart';

// class SelectPrinterScreen extends StatefulWidget {
//   const SelectPrinterScreen({Key? key}) : super(key: key);

//   @override
//   _SelectPrinterScreenState createState() => _SelectPrinterScreenState();
// }

// class _SelectPrinterScreenState extends State<SelectPrinterScreen> {
//   BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   List<BluetoothDevice> devices = [];
//   String deviceMsg = "";
//   bool _connected = false;
//   late BluetoothDevice _device;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//       initPrinter();
//       // initBluetooth();
//     });
//   }

//   Future<void> initPrinter() async {
//     bluetoothPrint.startScan(timeout: Duration(seconds: 5));
//     if (!mounted) return;
//     bluetoothPrint.scanResults.listen((event) {
//       if (!mounted) return;
//       setState(() {
//         devices = event;
//         if (devices.isEmpty) {
//           setState(() {
//             deviceMsg = "No Devices";
//           });
//         }
//       });
//     });
//   }

//   Future<void> initBluetooth() async {
//     bluetoothPrint.startScan(timeout: Duration(seconds: 4));

//     bool isConnected = await bluetoothPrint.isConnected ?? false;

//     bluetoothPrint.state.listen((state) {
//       print('cur device status: $state');

//       switch (state) {
//         case BluetoothPrint.CONNECTED:
//           setState(() {
//             _connected = true;
//             deviceMsg = 'connect success';
//           });
//           break;
//         case BluetoothPrint.DISCONNECTED:
//           setState(() {
//             _connected = false;
//             deviceMsg = 'disconnect success';
//           });
//           break;
//         default:
//           break;
//       }
//     });

//     if (!mounted) return;

//     if (isConnected) {
//       setState(() {
//         _connected = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Select Printer",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       drawer: DrawerWidget(
//         selectedScreen: "Select Printer",
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 bluetoothPrint.startScan(timeout: Duration(seconds: 5));
//               },
//               child: Text("Reload")),
//           StreamBuilder<List<BluetoothDevice>>(
//             stream: bluetoothPrint.scanResults,
//             initialData: [],
//             builder: (c, snapshot) => Column(
//               children: snapshot.data!
//                   .map((d) => ListTile(
//                         title: Text(d.name ?? ''),
//                         subtitle: Text(d.address!),
//                         onTap: () async {
//                           setState(() {
//                             _device = d;
//                           });
//                         },
//                         trailing: _device != null && _device.address == d.address
//                             ? Icon(
//                                 Icons.check,
//                                 color: Colors.green,
//                               )
//                             : null,
//                       ))
//                   .toList(),
//             ),
//           ),
//           Container(
//             height: 200,
//             child: Container(
//                 child: devices.isEmpty
//                     ? Center(
//                         child: Text(deviceMsg),
//                       )
//                     : ListView.builder(
//                         itemCount: devices.length,
//                         itemBuilder: (c, i) {
//                           return ListTile(
//                             leading: Icon(Icons.print),
//                             title: Text(devices[i].name!),
//                             subtitle: Text(devices[i].address!),
//                             onTap: () {},
//                           );
//                         })),
//           ),
//         ],
//       ),
//     );
//   }
// }
