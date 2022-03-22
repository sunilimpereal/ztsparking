import 'package:flutter/material.dart';
import 'package:ztsparking/authentication/login/login_page.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';
import 'package:ztsparking/entry/ticket/screens/ticektHistory.dart';
import 'package:ztsparking/entry/ticket/screens/ticket_summary_screen.dart';
import 'package:ztsparking/main.dart';
import 'package:ztsparking/services/printer.dart';


class MenuDropDown extends StatefulWidget {
  Function logout;
  MenuDropDown({Key? key, required this.logout}) : super(key: key);

  @override
  _MenuDropDownState createState() => _MenuDropDownState();
}

class _MenuDropDownState extends State<MenuDropDown> {
  String selected = "";

  bool opened = false;
  OverlayEntry? entry;
  final layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
  }

  showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            opened = !opened;
          });

          hideOverlay();
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                width: MediaQuery.of(context).size.width * 0.5,
                child: CompositedTransformFollower(
                    link: layerLink,
                    offset: Offset(
                        -MediaQuery.of(context).size.width * 0.5 + (size.width - size.width / 5),
                        size.height - size.height / 5),
                    showWhenUnlinked: false,
                    child: buildOverlay()),
              ),
            ],
          ),
        ),
      ),
    );
    overlay?.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  Widget buildOverlay() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Material(
        elevation: 8,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: 100,
          color: Colors.transparent,
          child: Menulist(
            logout: () {
              widget.logout();
            },
            exitontap: () {
              setState(() {
                hideOverlay();
                opened = !opened;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: layerLink,
        child: Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                1100,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.segment,
                size: 32,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  opened = !opened;
                  showOverlay();
                });
              },
            )));
  }
}

class Menulist extends StatefulWidget {
  Function exitontap;
  Function logout;
  Menulist({Key? key, required this.exitontap, required this.logout}) : super(key: key);

  @override
  State<Menulist> createState() => _MenulistState();
}

class _MenulistState extends State<Menulist> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      TicketProvider.of(context).getTicketReport(showonlyHour: true);
      TicketProvider.of(context).getLineItemSumry(DateTime.now());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.green,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          menuItem(
            name: "Select Printer",
            icon: Icons.print,
            ontap: () async {
              widget.exitontap();
              await Printer().selectPrinter();
            },
          ),
          menuItem(
            name: "Tickets",
            icon: Icons.receipt_long,
            ontap: () {
              widget.exitontap();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TickethistoryScreen(),
                ),
              );
            },
          ),
          menuItem(
            name: "Summary",
            icon: Icons.summarize,
            ontap: () {
              widget.exitontap();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TicketSummaryScreen(),
                ),
              );
            },
          ),
          menuItem(
            name: "Logout",
            icon: Icons.logout,
            ontap: () {
              widget.exitontap();
              Navigator.pop(context);
             
                widget.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget menuItem({
    required String name,
    required IconData icon,
    required Function ontap,
  }) {
    return Material(
      color: Colors.green[400],
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.greenAccent,
            highlightColor: Colors.green,
            onTap: () {
              ontap();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: appFonts.poppins,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
