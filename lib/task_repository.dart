import 'package:flutter/material.dart';

class TaskRepository {
  static final ValueNotifier<List<Map<String, dynamic>>> tasks =
      ValueNotifier<List<Map<String, dynamic>>>([
        {
          'id': 'task-1',
          'name': 'Alex Johnson',
          'title': 'Need help moving a desk',
          'description':
              'Need assistance moving a desk from garage to upstairs room.',
          'distance': '0.8 km away',
          'karma': '20',
          'time': 'Today • 5:00 PM',
          'category': 'Moving',
          'urgency': 'Normal',
          'status': 'Open',
          'helper': 'Waiting for helper',
          'location': 'Garage to upstairs room',
          'image': 'https://randomuser.me/api/portraits/men/32.jpg',
        },
        {
          'id': 'task-2',
          'name': 'Sarah Lee',
          'title': 'Need ladder for wall painting',
          'description':
              'Looking to borrow a ladder for painting my living room walls.',
          'distance': '1.4 km away',
          'karma': '10',
          'time': 'Tomorrow • 10:00 AM',
          'category': 'Borrowing',
          'urgency': 'Low',
          'status': 'Open',
          'helper': 'Waiting for helper',
          'location': 'Living room',
          'image': 'https://randomuser.me/api/portraits/women/44.jpg',
        },
        {
          'id': 'task-3',
          'name': 'Michael Brown',
          'title': 'Need grocery pickup from Aldi',
          'description': 'Need help picking up groceries from Aldi after work.',
          'distance': '0.5 km away',
          'karma': '15',
          'time': 'Today • 7:30 PM',
          'category': 'Errands',
          'urgency': 'Urgent',
          'status': 'Open',
          'helper': 'Waiting for helper',
          'location': 'Aldi store',
          'image': 'https://randomuser.me/api/portraits/men/41.jpg',
        },
      ]);

  static final ValueNotifier<List<Map<String, String>>> notifications =
      ValueNotifier<List<Map<String, String>>>([]);

  static final ValueNotifier<Map<String, String>> profileImages =
      ValueNotifier<Map<String, String>>({});

  static String _generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static String profileImageFor(String userName) {
    return profileImages.value[userName] ?? '';
  }

  static void setProfileImage(String userName, String imagePath) {
    if (userName.isEmpty || imagePath.isEmpty) return;

    profileImages.value = {...profileImages.value, userName: imagePath};
  }

  static void addTask(Map<String, dynamic> task) {
    final newTask = {
      'id': task['id'] ?? _generateId(),
      'name': task['name'] ?? 'Unknown',
      'title': task['title'] ?? '',
      'description': task['description'] ?? '',
      'distance': task['distance'] ?? 'Nearby',
      'karma': task['karma'] ?? '0',
      'time': task['time'] ?? 'Today • Now',
      'category': task['category'] ?? 'General',
      'urgency': task['urgency'] ?? 'Normal',
      'status': task['status'] ?? 'Open',
      'helper': task['helper'] ?? 'Waiting for helper',
      'location': task['location'] ?? '',
      'image':
          task['image'] ?? 'https://randomuser.me/api/portraits/lego/1.jpg',
    };
    tasks.value = [newTask, ...tasks.value];
  }

  static void updateTask(String id, Map<String, dynamic> changes) {
    tasks.value = tasks.value.map((task) {
      if (task['id'] == id) {
        return {...task, ...changes};
      }
      return task;
    }).toList();
  }

  static void deleteTask(String id) {
    tasks.value = tasks.value.where((task) => task['id'] != id).toList();
  }

  static void acceptTask(String id, String helperName) {
    final currentTasks = List<Map<String, dynamic>>.from(tasks.value);
    final index = currentTasks.indexWhere((task) => task['id'] == id);
    if (index == -1) return;

    final task = currentTasks[index];
    if (task['status'] != 'Open') return;

    final updated = {...task, 'status': 'Accepted', 'helper': helperName};
    currentTasks[index] = updated;
    tasks.value = currentTasks;
    notifyUser(
      task['name'],
      'Your request "${task['title']}" was accepted by $helperName.',
    );
  }

  static int sendEmergencyAlert(String senderName) {
    final recipients = <String>{};

    for (final task in tasks.value) {
      final taskOwner = task['name']?.toString() ?? '';
      final helper = task['helper']?.toString() ?? '';

      if (taskOwner.isNotEmpty && taskOwner != senderName) {
        recipients.add(taskOwner);
      }

      if (helper.isNotEmpty &&
          helper != 'Waiting for helper' &&
          helper != senderName) {
        recipients.add(helper);
      }
    }

    final message =
        'Emergency SOS from $senderName. Please check in or offer immediate help.';
    final emergencyTask = {
      'id': 'sos-${_generateId()}',
      'name': senderName,
      'title': 'Emergency assistance needed',
      'description':
          '$senderName has triggered an SOS alert and needs immediate help nearby.',
      'distance': 'Nearby',
      'karma': '0',
      'time': 'Now',
      'category': 'Emergency',
      'urgency': 'Urgent',
      'status': 'Open',
      'helper': 'Waiting for helper',
      'location': 'Current location',
      'image': 'https://randomuser.me/api/portraits/lego/1.jpg',
    };

    tasks.value = [emergencyTask, ...tasks.value];
    notifications.value = [
      ...notifications.value,
      ...recipients.map((user) => {'user': user, 'message': message}),
    ];

    return recipients.length;
  }

  static void notifyUser(String userName, String message) {
    notifications.value = [
      ...notifications.value,
      {'user': userName, 'message': message},
    ];
  }

  static void clearNotificationsForUser(String userName) {
    notifications.value = notifications.value
        .where((note) => note['user'] != userName)
        .toList();
  }
}
