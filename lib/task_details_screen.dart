import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_screen.dart';
import 'sos_button.dart';

import 'ui/ui_helpers.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> task;
  final String userName;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      floatingActionButton: SosButton(userName: userName),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kSpacing),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // TOP BAR
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "TASK DETAILS",

                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,

                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 20),

              // IMAGE
              Container(
                width: double.infinity,
                height: 320,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: Colors.grey),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildTaskImage(task['image']),
                ),
              ),

              const SizedBox(height: 20),

              // TITLE
              Text(
                task['title'],

                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // DISTANCE + KARMA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 28),

                      const SizedBox(width: 6),

                      Text(
                        task['distance'],

                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,

                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(Icons.stars_outlined, size: 28),

                      const SizedBox(width: 6),

                      Text(
                        "${task['karma']} Karma",

                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,

                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // DESCRIPTION
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(14),

                  border: Border.all(color: Colors.grey.shade400),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Description",

                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      task['description'],

                      style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Divider(color: Colors.grey[500], thickness: 1),

              const SizedBox(height: 20),

              // TASK DETAILS
              Text(
                "Task Details",

                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,

                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 16),

              detailRow("Date:", "29 April, 2026"),

              detailRow("Time:", task['time']),

              detailRow("Category:", task['category']),

              detailRow("Offered Karma Points:", "${task['karma']} Points"),

              const SizedBox(height: 30),

              Divider(color: Colors.grey[500], thickness: 1),

              const SizedBox(height: 20),

              // POSTED BY
              Text(
                "Posted by",

                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,

                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: SizedBox(
                        width: 68,
                        height: 68,
                        child: _buildTaskImage(task['image']),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          task['name'],

                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: const [
                            Icon(Icons.star, size: 18),

                            Icon(Icons.star, size: 18),

                            Icon(Icons.star, size: 18),

                            Icon(Icons.star, size: 18),

                            Icon(Icons.star_border, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.black),

                      const SizedBox(width: 4),

                      Text(
                        "Verified User",

                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // BUTTONS
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E8F61),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                name: task['name'],

                                avatarUrl: task['image'],
                              ),
                            ),
                          );
                        },

                        child: Text(
                          "Message",

                          style: GoogleFonts.poppins(
                            color: Colors.white,

                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: SizedBox(
                      height: 56,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E8F61),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          showDialog(
                            context: context,

                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              title: const Icon(
                                Icons.check_circle,

                                color: Colors.green,

                                size: 70,
                              ),

                              content: Text(
                                "Task accepted successfully!",

                                textAlign: TextAlign.center,

                                style: GoogleFonts.poppins(
                                  fontSize: 18,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),

                                    onPressed: () {
                                      Navigator.pop(context);

                                      Navigator.push(
                                        context,

                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            name: task['name'],

                                            avatarUrl: task['image'],
                                          ),
                                        ),
                                      );
                                    },

                                    child: const Text("Start Chat"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        child: Text(
                          "Accept Task",

                          style: GoogleFonts.poppins(
                            color: Colors.white,

                            fontSize: 18,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskImage(String imageUrl) {
    if (!kIsWeb && imageUrl.isNotEmpty && File(imageUrl).existsSync()) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 40,
          ),
        );
      },
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 170,

            child: Text(
              title,

              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,

                fontSize: 16,
              ),
            ),
          ),

          Expanded(
            child: Text(value, style: GoogleFonts.poppins(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
