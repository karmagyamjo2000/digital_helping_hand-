import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'ui/ui_helpers.dart';

class MessagesScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const MessagesScreen({super.key, this.onBack});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Map<String, dynamic>> chats = [
    {
      'name': 'John Martinez',
      'msg': 'Sure, I can help with the move tomorrow.',
      'time': '10:12 AM',
      'avatar': 'https://i.pravatar.cc/150?img=35',
      'unread': 2,
      'status': 'Online',
    },
    {
      'name': 'Sarah Lee',
      'msg': 'Thanks! I’ll drop it off at 3 PM.',
      'time': 'Yesterday',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'unread': 0,
      'status': 'Away',
    },
    {
      'name': 'Michael Brown',
      'msg': 'Can you pick up groceries from Aldi?',
      'time': 'Mon',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'unread': 1,
      'status': 'Busy',
    },
    {
      'name': 'Amina Patel',
      'msg': 'I’m available for tutoring after 6 PM.',
      'time': 'Sun',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'unread': 0,
      'status': 'Online',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.98),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: widget.onBack,
              )
            : Navigator.canPop(context)
            ? const BackButton(color: Colors.black)
            : null,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.handshake, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              "Messages",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpacing),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search chats',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(Icons.filter_alt_outlined, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: chats.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              name: chat['name'] as String,
                              avatarUrl: chat['avatar'] as String,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.blue.shade50,
                              backgroundImage: NetworkImage(
                                chat['avatar'] as String,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          chat['name'] as String,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        chat['time'] as String,
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    chat['msg'] as String,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    chat['status'] as String,
                                    style: GoogleFonts.poppins(
                                      color: Colors.green.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if ((chat['unread'] as int) > 0) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '${chat['unread']}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
