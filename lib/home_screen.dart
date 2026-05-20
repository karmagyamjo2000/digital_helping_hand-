import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'task_details_screen.dart';
import 'profile_screen.dart';
import 'task_repository.dart';

import 'ui/ui_helpers.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final int userKarma;

  const HomeScreen({super.key, required this.userName, this.userKarma = 75});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);

    searchController.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _showNotifications(List<Map<String, String>> notifications) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (notifications.isEmpty)
                Text(
                  'No new notifications.',
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                )
              else
                ...notifications.map(
                  (note) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      note['message'] ?? '',
                      style: GoogleFonts.poppins(color: Colors.grey[800]),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  TaskRepository.clearNotificationsForUser(widget.userName);
                  Navigator.pop(context);
                },
                child: Text(
                  'Clear Notifications',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectCategory(String cat) {
    setState(() {
      if (selectedCategory == cat) {
        selectedCategory = '';
      } else {
        selectedCategory = cat;
      }
    });
  }

  List<Map<String, dynamic>> _filterTasks(List<Map<String, dynamic>> taskList) {
    final query = searchController.text.toLowerCase();

    return taskList.where((t) {
      final title = (t['title'] as String).toLowerCase();

      final name = (t['name'] as String).toLowerCase();

      final category = (t['category'] as String);

      final matchesQuery =
          query.isEmpty || title.contains(query) || name.contains(query);

      final matchesCategory =
          selectedCategory.isEmpty || category == selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
  }

  Widget _buildAvatar(String imageUrl, {double radius = 24, String name = ''}) {
    Widget imageWidget;

    if (imageUrl.isEmpty) {
      imageWidget = _buildInitialsAvatar(name, radius);
    } else if (!kIsWeb && File(imageUrl).existsSync()) {
      imageWidget = Image.file(File(imageUrl), fit: BoxFit.cover);
    } else {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildInitialsAvatar(name, radius);
        },
      );
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: ClipOval(child: imageWidget),
    );
  }

  Widget _buildInitialsAvatar(String name, double radius) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      color: Colors.blue.shade50,
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: GoogleFonts.poppins(
          color: Colors.blue.shade700,
          fontSize: radius * 0.62,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color urgencyColor(String urgency) {
    switch (urgency) {
      case "Urgent":
        return Colors.red;

      case "Low":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  String _distanceText(Map<String, dynamic> task) {
    return task['distance'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.98),
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
              "Digital Helping Hand",

              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          ValueListenableBuilder<List<Map<String, String>>>(
            valueListenable: TaskRepository.notifications,
            builder: (context, notifications, _) {
              final userNotifications = notifications
                  .where((note) => note['user'] == widget.userName)
                  .toList();
              return IconButton(
                onPressed: () => _showNotifications(userNotifications),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.black87),
                    if (userNotifications.isNotEmpty)
                      Positioned(
                        right: -1,
                        top: -1,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${userNotifications.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kSpacing),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Hello, ${widget.userName.isNotEmpty ? widget.userName : 'John'} 👋",

                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Find nearby tasks and help your community",

                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  ValueListenableBuilder<Map<String, String>>(
                    valueListenable: TaskRepository.profileImages,
                    builder: (context, profileImages, _) {
                      final profileImage = profileImages[widget.userName] ?? '';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                userName: widget.userName,

                                userKarma: widget.userKarma,
                              ),
                            ),
                          );
                        },

                        child: _buildAvatar(
                          profileImage,
                          radius: 28,
                          name: widget.userName,
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // KARMA CARD
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Your Karma Points",

                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "${widget.userKarma}",

                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Icon(Icons.stars, color: Colors.amber, size: 50),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH BAR
              TextField(
                controller: searchController,

                decoration: InputDecoration(
                  hintText: 'Search nearby tasks...',

                  prefixIcon: const Icon(Icons.search),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // CATEGORY CHIPS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
                  children: [
                    categoryChip("Moving"),
                    categoryChip("Borrowing"),
                    categoryChip("Errands"),
                    categoryChip("Cleaning"),
                    categoryChip("Emergency"),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Nearby Requests",

                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // TASK LIST
              Expanded(
                child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: TaskRepository.tasks,

                  builder: (context, tasks, _) {
                    final filteredTasks = _filterTasks(tasks);

                    if (filteredTasks.isEmpty) {
                      return Center(
                        child: Text(
                          'No tasks found',

                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredTasks.length,

                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => TaskDetailsScreen(
                                  task: task,
                                  userName: widget.userName,
                                ),
                              ),
                            );
                          },

                          child: Container(
                            margin: const EdgeInsets.only(bottom: 18),

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(20),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),

                                  blurRadius: 10,

                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // USER ROW
                                Row(
                                  children: [
                                    _buildAvatar(
                                      task['image'],
                                      radius: 25,
                                      name: task['name'],
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                task['name'],

                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,

                                                  fontSize: 16,
                                                ),
                                              ),

                                              const SizedBox(width: 6),

                                              const Icon(
                                                Icons.verified,

                                                color: Colors.blue,

                                                size: 18,
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 2),

                                          Text(
                                            _distanceText(task),

                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,

                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: Text(
                                        "${task['karma']} KP",

                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,

                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                // TITLE
                                Text(
                                  task['title'],

                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // DESCRIPTION
                                Text(
                                  task['description'],

                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,

                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[700],

                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // TIME + URGENCY
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,

                                      size: 18,
                                      color: Colors.grey,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      task['time'],

                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                      ),
                                    ),

                                    const Spacer(),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),

                                      decoration: BoxDecoration(
                                        color: urgencyColor(
                                          task['urgency'],
                                        ).withValues(alpha: 0.12),

                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: Text(
                                        task['urgency'],

                                        style: GoogleFonts.poppins(
                                          color: urgencyColor(task['urgency']),

                                          fontWeight: FontWeight.w600,

                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                // CATEGORY + BUTTON
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,

                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: Text(
                                        task['category'],

                                        style: GoogleFonts.poppins(
                                          color: Colors.green.shade800,

                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    if (task['name'] != widget.userName &&
                                        task['status'] == 'Open')
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2E7D32,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          TaskRepository.acceptTask(
                                            task['id'],
                                            widget.userName,
                                          );
                                          setState(() {});
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'You accepted "${task['title']}"',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Accept Task",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Text(
                                          task['name'] == widget.userName
                                              ? 'Your request'
                                              : task['status'] == 'Accepted'
                                              ? 'Accepted by ${task['helper']}'
                                              : task['status'],
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  Widget categoryChip(String text) {
    final isSelected = selectedCategory == text;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: GestureDetector(
        onTap: () => _selectCategory(text),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.white,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(color: Colors.grey.shade300),
          ),

          child: Text(
            text,

            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
