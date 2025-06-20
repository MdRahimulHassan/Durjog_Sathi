import 'package:flutter/material.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsScreen> {
  List<Map<String, String>> contacts = [
    {"name": "Police", "Rescue Area": "All" , "number": "100"},
    {"name": "Ambulance", "Rescue Area": "All" ,"number": "102"},
    {"name": "Fire Brigade", "Rescue Area": "All" , "number": "101"},
  ];

  void _addContact() {
    TextEditingController nameController = TextEditingController();
    TextEditingController rescueArea = TextEditingController();
    TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Emergency Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: rescueArea,
                decoration: const InputDecoration(labelText: "Rescue Area"),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && rescueArea.text.isNotEmpty && numberController.text.isNotEmpty) {
                  setState(() {
                    contacts.add({
                      "name": nameController.text,
                      "Rescue Area": rescueArea.text,
                      "number": numberController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Contacts")),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.contact_phone, color: Colors.red),
            title: Text(contacts[index]["name"]!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rescue Area: ${contacts[index]["Rescue Area"]!}"),
                Text("Phone: ${contacts[index]["number"]!}"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  contacts.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
