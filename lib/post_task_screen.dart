import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'task_repository.dart';
import 'ui/ui_helpers.dart';

class PostTaskScreen extends StatefulWidget {
  final String userName;

  const PostTaskScreen({super.key, required this.userName});

  @override
  State<PostTaskScreen> createState() => _PostTaskScreenState();
}

class _PostTaskScreenState extends State<PostTaskScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  double karma = 20;

  File? selectedImage;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> categories = [
    "Moving",
    "Borrowing",
    "Errands",
    "Shopping",
    "Cleaning",
    "Tutoring",
    "Emergency",
    "Other",
  ];

  Future<void> pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null && !kIsWeb) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,

      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void submitTask() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter task title")));
      return;
    }

    TaskRepository.addTask({
      "name": widget.userName,
      "title": titleController.text,
      "description": descriptionController.text,
      "distance": "1.1 km away",
      "karma": karma.toInt().toString(),
      "time":
          "${selectedDate != null ? selectedDate.toString().split(' ')[0] : 'Today'} • ${selectedTime != null ? selectedTime!.format(context) : 'Now'}",
      "category": categoryController.text.isEmpty
          ? "General"
          : categoryController.text,
      "urgency": "Normal",
      "location": locationController.text,
      "image": selectedImage?.path,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task posted successfully")));

    Navigator.pop(context);
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Text(
        text,

        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: Colors.grey.shade400),
      ),

      child: TextField(
        controller: controller,
        maxLines: maxLines,

        decoration: const InputDecoration(
          border: InputBorder.none,

          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,

        onPressed: () {},

        child: Text(
          "SOS",

          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kSpacing),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              Center(
                child: Text(
                  "POST TASK",

                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // TASK TITLE
              fieldLabel("Task Title"),

              textField(controller: titleController),

              const SizedBox(height: 24),

              // CATEGORY DROPDOWN
              fieldLabel("Category"),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: Colors.grey.shade400),
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: categoryController.text.isEmpty
                        ? null
                        : categoryController.text,

                    hint: Text("Select Category", style: GoogleFonts.poppins()),

                    isExpanded: true,

                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,

                        child: Text(category, style: GoogleFonts.poppins()),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        categoryController.text = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // DATE TIME
              fieldLabel("Date and Time"),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: pickDate,

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(color: Colors.grey.shade400),
                        ),

                        child: Text(
                          selectedDate == null
                              ? "Select Date"
                              : selectedDate!.toString().split(' ')[0],

                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: pickTime,

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(color: Colors.grey.shade400),
                        ),

                        child: Text(
                          selectedTime == null
                              ? "Select Time"
                              : selectedTime!.format(context),

                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // KARMA
              fieldLabel("Karma Points Reward"),

              Text(
                "Set how many Karma Points you want to offer",

                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),

              Slider(
                value: karma,
                min: 5,
                max: 50,
                divisions: 9,

                activeColor: const Color(0xFF43A047),

                label: karma.toInt().toString(),

                onChanged: (value) {
                  setState(() {
                    karma = value;
                  });
                },
              ),

              Text(
                "${karma.toInt()} Points",

                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // DESCRIPTION
              fieldLabel("Description"),

              textField(controller: descriptionController, maxLines: 5),

              const SizedBox(height: 24),

              // LOCATION
              fieldLabel("Location"),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: Colors.green),
                ),

                child: TextField(
                  controller: locationController,

                  decoration: const InputDecoration(
                    border: InputBorder.none,

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // IMAGE
              fieldLabel("Upload Image"),

              GestureDetector(
                onTap: pickImage,

                child: Container(
                  height: 180,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(14),

                    border: Border.all(color: Colors.grey.shade400),
                  ),

                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),

                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Tap to upload image",

                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 40),

              // POST BUTTON
              Center(
                child: SizedBox(
                  width: 220,
                  height: 58,
                  child: GradientButton(
                    onPressed: submitTask,
                    child: Text(
                      "Post Task",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
