import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'platform_stub.dart' if (dart.library.io) 'dart:io' as io;
import 'ui/ui_helpers.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const ChatScreen({super.key, required this.name, required this.avatarUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;

  final List<Map<String, dynamic>> messages = [
    {
      'me': false,
      'text': 'Hi! Thanks for reaching out. How can I help today?',
      'time': '09:10 AM',
    },
    {
      'me': true,
      'text': 'I’m looking for help moving a sofa on Saturday.',
      'time': '09:12 AM',
    },
    {
      'me': false,
      'text': 'That works for me. What time would you like?',
      'time': '09:13 AM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'me': true, 'text': text, 'time': 'Now'});
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addMessage(String text) {
    setState(() {
      messages.add({'me': true, 'text': text, 'time': 'Now'});
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(type: FileType.any);
    if (!mounted || result == null || result.files.isEmpty) return;

    _addMessage('File: ${result.files.first.name}');
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (!mounted || result == null || result.files.isEmpty) return;

    _addMessage('Photo: ${result.files.first.name}');
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AttachmentAction(
                  icon: Icons.insert_drive_file,
                  label: 'File',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickFile();
                  },
                ),
                _AttachmentAction(
                  icon: Icons.photo_camera,
                  label: 'Photo',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPhoto();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        _addMessage('Voice message: ${path.split(RegExp(r"[\\/]+")).last}');
      }
      return;
    }

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice recording is not supported on web.'),
        ),
      );
      return;
    }

    final hasPermission = await _audioRecorder.hasPermission();
    if (!mounted) return;

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }

    final filePath =
        '${io.Directory.systemTemp.path}${io.Platform.pathSeparator}voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );
    if (!mounted) return;

    setState(() {
      _isRecording = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasDraft = _messageController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.98),
        leading: Navigator.canPop(context)
            ? const BackButton(color: Colors.black)
            : null,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: NetworkImage(widget.avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Active 5m ago',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: kSpacing,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message['me'] as bool;
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.76,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF2E7D32) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isMe ? 18 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['text'] as String,
                            style: GoogleFonts.poppins(
                              color: isMe ? Colors.white : Colors.grey[900],
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message['time'] as String,
                            style: GoogleFonts.poppins(
                              color: isMe ? Colors.white70 : Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white.withValues(alpha: 0.98),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.attach_file),
                            color: Colors.grey[700],
                            tooltip: 'Attach',
                            onPressed: _showAttachmentSheet,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              minLines: 1,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: _isRecording
                                    ? 'Recording voice message...'
                                    : 'Type a message...',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: hasDraft ? _sendMessage : _toggleRecording,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hasDraft
                            ? Icons.send
                            : _isRecording
                            ? Icons.stop
                            : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
