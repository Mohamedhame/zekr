import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/database/notes_database.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/controller/notification/notify_helper.dart';
import 'package:zekr/view/task/notes.dart';
import 'package:zekr/widgets/input_field.dart';

class AddTaskBar extends StatefulWidget {
  final int? reminderId;
  AddTaskBar({super.key, this.reminderId});

  @override
  State<AddTaskBar> createState() => _AddTaskBarState();
}

class _AddTaskBarState extends State<AddTaskBar> {
  final HomeController controller = Get.find<HomeController>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  // String _selectedRepeat = "بدون";
  // List<String> repeatList = ['بدون', 'عمل', 'شخصي'];
  DateTime _reminderTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: controller.bgColor.value,
          appBar: AppBar(
            backgroundColor: controller.widgetColor.value,
            foregroundColor: controller.textColor.value,
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: controller.widgetColor.value,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.reminderId == null
                          ? "إضافة ملاحظة"
                          : "عدل ملاحظتك",
                      style:
                          ourStyle(color: controller.textColor.value, size: 22),
                    ),
                  ),
                  //===================
                  MyInputField(
                    title: "العنوان",
                    hint: "أدخل العنوان",
                    controller: _titleController,
                    style:
                        ourStyle(color: controller.textColor.value, size: 18),
                  ),
                  //================
                  MyInputField(
                    title: "الملاحظه",
                    hint: "أدخل ملاحظتك",
                    controller: _noteController,
                    style:
                        ourStyle(color: controller.textColor.value, size: 18),
                  ),
                  //===================
                  MyInputField(
                    title: "التاريخ",
                    hint: DateFormat('yyyy-MM-dd').format(_reminderTime),
                    widget: IconButton(
                        onPressed: () {
                          _selectDate();
                        },
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        )),
                    style: ourStyle(color: controller.textColor.value),
                  ),
                  //==========================
                  MyInputField(
                    title: "الوقت",
                    hint: DateFormat('hh:mm a').format(_reminderTime),
                    widget: IconButton(
                        onPressed: () {
                          _selectTime();
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        )),
                    style: ourStyle(color: controller.textColor.value),
                  ),
                  //====================
                 
                  const SizedBox(height: 18),
                  //=========================
                  GestureDetector(
                    onTap: () {
                      _validateData();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: controller.widgetColor.value),
                      alignment: Alignment.center,
                      child: Text(
                        widget.reminderId == null ? "إضافة مهمة" : "تعديل",
                        style: ourStyle(
                            color: controller.textColor.value, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ));
  }

  //=======================
  void _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.offAll(() => Notes());
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: controller.bgColor.value,
          colorText: controller.textColor.value,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

//========================
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _reminderTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _reminderTime = DateTime(picked.year, picked.month, picked.day,
            _reminderTime.hour, _reminderTime.minute);
      });
    }
  }

  //=======================
  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: _reminderTime.hour, minute: _reminderTime.minute));
    if (picked != null) {
      setState(() {
        _reminderTime = DateTime(_reminderTime.year, _reminderTime.month,
            _reminderTime.day, picked.hour, picked.minute);
      });
    }
  }

  void _addTaskToDB() async {
    Map<String, dynamic> addTask = {
      'title': _titleController.text,
      'description': _noteController.text,
      'isActive': 1,
      'remindersTime': _reminderTime.toIso8601String(),
      'category': _noteController.text
    };
    if (widget.reminderId == null) {
      final reminderId = await NotesDatabase.addReminder(addTask);
      NotifyHelper.scheduleNotificationDetails(reminderId,
          _titleController.text, _noteController.text, _reminderTime);
    } else {
      await NotesDatabase.updateReminder(widget.reminderId!, addTask);
      NotifyHelper.scheduleNotificationDetails(widget.reminderId!,
          _titleController.text, _noteController.text, _reminderTime);
    }
  }

  //============

  //=======================
}
