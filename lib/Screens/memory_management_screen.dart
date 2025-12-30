import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llama_chat_app/Animation/background_animation.dart';
import 'package:llama_chat_app/Controllers/local_database.dart';

class MemoryManagementScreen extends StatefulWidget {
  final bool isAnimationAllowed;

  const MemoryManagementScreen({super.key, required this.isAnimationAllowed});

  @override
  _MemoryManagementScreenState createState() => _MemoryManagementScreenState();
}

class _MemoryManagementScreenState extends State<MemoryManagementScreen> {
  late Future<List<Map<String, dynamic>>> _memories;
  final ChatDatabaseController chatDatabaseController =
      Get.put(ChatDatabaseController());

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  void _loadMemories() {
    _memories = chatDatabaseController.database.then((db) {
      return db.query('memory', orderBy: 'id ASC');
    });
  }

  Future<void> _addMemory() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shadowColor: Colors.blue,
        title: Text(
          'Add Memory',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        content: SingleChildScrollView(
          child: TextField(
            cursorColor: Colors.blue,
            style: TextStyle(color: Colors.white),
            controller: controller,
            maxLines: 5, // Multiline input for better usability
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                border: OutlineInputBorder(),
                hintText: 'Enter memory description...',
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white10),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 15, 12, 24)),
                shadowColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () async {
              final description = controller.text.trim();
              if (description.isNotEmpty) {
                await chatDatabaseController.saveMemory(description);
                _loadMemories();
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editMemory(int id, String currentDescription) async {
    final controller = TextEditingController(text: currentDescription);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shadowColor: Colors.blue,
        title: Text(
          'Edit Memory',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        content: SingleChildScrollView(
          child: TextField(
            cursorColor: Colors.blue,
            style: TextStyle(color: Colors.white),
            controller: controller,
            maxLines: 5, // Multiline input for better usability
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Update memory description...',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white10,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 15, 12, 24)),
                shadowColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () async {
              final newDescription = controller.text.trim();
              if (newDescription.isNotEmpty) {
                final db = await chatDatabaseController.database;
                await db.update(
                  'memory',
                  {'description': newDescription},
                  where: 'id = ?',
                  whereArgs: [id],
                );
                _loadMemories();
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int id) async {
  await Get.defaultDialog(
    title: "Delete Memory",
    middleText: "Are you sure you want to delete this memory?",
    titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    middleTextStyle: TextStyle(color: Colors.white70),
    backgroundColor: Colors.black87,
    radius: 8,
    textCancel: "Cancel",
    cancelTextColor: Colors.white,
    textConfirm: "Delete",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onCancel: () {
      // Simply dismisses the dialog if canceled
    },
    onConfirm: () async {
      await _deleteMemory(id); // Call the delete memory function
      Get.back(); // Close the dialog after deletion
    },
  );
}


  Future<void> _deleteMemory(int id) async {
    final db = await chatDatabaseController.database;
    await db.delete(
      'memory',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadMemories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Memory Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _memories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          final memories = snapshot.data ?? [];
          if (memories.isEmpty) {
            return Center(
              child: Text(
                'No memories found. Add one to get started!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          var padding = Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: memories.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade800),
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return Card(
                    color: const Color.fromARGB(144, 33, 33, 33),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        memory['description'] ?? 'No description',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editMemory(memory['id'], memory['description']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteDialog(memory['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          return widget.isAnimationAllowed? AdvancedNeuralNetworkAnimation(
            child: padding,
          ): padding;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemory,
        backgroundColor: Colors.white12,
        child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: Colors.black87,
                border: Border.all(color: Colors.white54, width: 2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white30, blurRadius: 4, spreadRadius: 4)
                ]),
            child: Icon(
              Icons.add,
              size: 40,
              color: Colors.blue,
            )),
      ),
    );
  }
}
