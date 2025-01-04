import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/database/notes_database.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/controller/notification/notify_helper.dart';
import 'package:zekr/view/task/add_task_bar.dart';

class Notes extends StatefulWidget {
  Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final HomeController controller = Get.find<HomeController>();
  List<Map<String, dynamic>> _reminders = [];
  //================
  Future<void> _loadReminders() async {
    final reminders = await NotesDatabase.getReminders();
    setState(() {
      _reminders = reminders;
    });
  }

  //==============
  Future<void> _deleteReminder(int id) async {
    await NotesDatabase.deleteReminder(id);
    NotifyHelper.cancelNotification(id);
  }

  //===============================
  Future<void> _toggleReminder(int id, bool isActive) async {
    await NotesDatabase.toggleReminder(id, isActive);
    if (isActive) {
      final reminder = _reminders.firstWhere((rem) => rem['id'] == id);
      NotifyHelper.scheduleNotificationDetails(id, reminder['title'],
          reminder['category'], DateTime.parse(reminder['remindersTime']));
    } else {
      NotifyHelper.cancelNotification(id);
    }
    _loadReminders();
  }

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  //========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor.value,
      appBar: AppBar(
        backgroundColor: controller.widgetColor.value,
        foregroundColor: controller.textColor.value,
      ),
      body: _reminders.isEmpty
          ? Center(
              child: Text(
                'لا يوجد مهام لعرضها',
                style: ourStyle(color: controller.textColor.value, size: 20),
              ),
            )
          : ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminders = _reminders[index];
                return Dismissible(
                    key: Key(reminders['id'].toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await _showDeleteConfirmationDialog(context);
                    },
                    onDismissed: (direction) {
                      _deleteReminder(reminders['id']);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'تم حذف المهمة',
                        style: ourStyle(
                            color: controller.textColor.value, size: 16),
                      )));
                    },
                    child: Card(
                      color: controller.widgetColor.value,
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.to(() => AddTaskBar(
                                reminderId: reminders['id'],
                              ));
                        },
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.teal,
                        ),
                        title: Text(reminders['title'],
                            style: ourStyle(
                                fontWeight: FontWeight.bold,
                                size: 20,
                                color: controller.textColor.value)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الوصف : ${reminders['category']}',
                              style: ourStyle(
                                  size: 20, color: controller.textColor.value),
                            ),
                            Text(
                              "تاريخ التنبية : ${parseIso8601Duration(reminders['remindersTime']).split(",")[0]}",
                              style: ourStyle(
                                  size: 16, color: controller.textColor.value),
                            ),
                            Text(
                              "وقت التنبية : ${parseIso8601Duration(reminders['remindersTime']).split(",")[1]}",
                              style: ourStyle(
                                  size: 16, color: controller.textColor.value),
                            ),
                          ],
                        ),
                        trailing: Switch(
                            activeColor: Colors.teal,
                            inactiveTrackColor: Colors.white,
                            inactiveThumbColor: Colors.black54,
                            value: reminders['isActive'] == 1,
                            onChanged: (value) {
                              _toggleReminder(reminders['id'], value);
                            }),
                      ),
                    ));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NotesDatabase.resetIdIfEmpty();
          Get.to(() => AddTaskBar());
        },
        backgroundColor: controller.widgetColor.value,
        child: Icon(
          Icons.add,
          color: controller.textColor.value,
        ),
      ),
    );
  }

  //============
  String parseIso8601Duration(String isoString) {
    String date = isoString.split("T")[0];
    List<String> timeAll = isoString.split("T")[1].split(":");
    String time = "${timeAll[0]}:${timeAll[1]}";
    String result = "$date,$time";
    return result;
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("حذف"),
          content: Text(
            "هل تريد الحذف؟",
            style: ourStyle(color: controller.textColor.value, size: 22),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("إلغاء")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "حذف",
                  style: TextStyle(color: Colors.redAccent),
                )),
          ],
        );
      },
    );
  }
}
