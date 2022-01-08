import 'package:flutter/material.dart';
import 'package:ztsparking/entry/entry_dash/data/models/generated_tickets.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';
import 'package:ztsparking/entry/ticket/widgets/reload_button.dart';
import 'package:ztsparking/entry/ticket/widgets/tciket_card.dart';


class TicketHistoryWrapper extends StatelessWidget {
  const TicketHistoryWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TicketProvider(
      context: context,
      child: TickethistoryScreen(),
    );
  }
}

class TickethistoryScreen extends StatefulWidget {
  const TickethistoryScreen({Key? key}) : super(key: key);

  @override
  _TickethistoryScreenState createState() => _TickethistoryScreenState();
}

class _TickethistoryScreenState extends State<TickethistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<GeneratedTickets>>(
          stream: TicketProvider.of(context).recentTicketStream,
          builder: (context, snapshot) {
            List<GeneratedTickets> tickets = snapshot.data ?? [];
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Text(
                                "Tikcet History",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          ZTSReloadButton()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: snapshot.hasData
                        ? ListView.builder(
                            cacheExtent: 10000,
                            itemCount: tickets.length,
                            itemBuilder: (c, index) {
                              return TicketCard(generatedTicket: tickets[index]);
                            })
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
