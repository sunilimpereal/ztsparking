import 'package:flutter/material.dart';

import '../data/repository/ticket_bloc.dart';

class ZTSReloadButton extends StatefulWidget {
  const ZTSReloadButton({Key? key}) : super(key: key);

  @override
  _ZTSReloadButtonState createState() => _ZTSReloadButtonState();
}

class _ZTSReloadButtonState extends State<ZTSReloadButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool loading = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: () {
          _controller.repeat();
          TicketProvider.of(context).getRecentTickets().then((value) {
            _controller.stop();
          });
        },
        icon: RotationTransition(
          turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
          child: const Icon(
            Icons.replay,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
