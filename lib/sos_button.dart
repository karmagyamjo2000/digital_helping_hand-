import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'task_repository.dart';

class SosButton extends StatelessWidget {
  final String userName;

  const SosButton({super.key, required this.userName});

  void _sendEmergencyAlert(BuildContext context) {
    final sender = userName.isNotEmpty ? userName : 'Someone nearby';
    final recipientCount = TaskRepository.sendEmergencyAlert(sender);
    final message = recipientCount == 0
        ? 'Emergency request posted. No other users are available to notify yet.'
        : 'Emergency request posted and sent to $recipientCount nearby user${recipientCount == 1 ? '' : 's'}.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.red,
      onPressed: () => _sendEmergencyAlert(context),
      child: Text(
        'SOS',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
