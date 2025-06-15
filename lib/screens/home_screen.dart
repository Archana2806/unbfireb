import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final nameC = TextEditingController();
  final cityC = TextEditingController();
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  static const Color pastelGreen = Color(0xFFB2F2BB);
  static const Color pastelPeach = Color(0xFFFFD6A5);
  static const Color brownText = Color(0xFF6B4F4F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelGreen.withOpacity(0.15),
      appBar: AppBar(
        backgroundColor: pastelPeach,
        title: const Text(
          "User List",
          style: TextStyle(color: brownText, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: brownText),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: pastelPeach),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(2, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cityC,
                    decoration: const InputDecoration(
                      labelText: "City",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      users.add({
                        'name': nameC.text.trim(),
                        'city': cityC.text.trim(),
                      });
                      nameC.clear();
                      cityC.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pastelPeach,
                      foregroundColor: brownText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Add User"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: users.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            doc['name'] ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: brownText,
                            ),
                          ),
                          subtitle: Text(
                            doc['city'] ?? '',
                            style: const TextStyle(color: brownText),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text("Are you sure you want to delete this user?"),
                                    actions: <Widget>[TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()), TextButton(child: const Text("Delete"), onPressed: () {users.doc(doc.id).delete(); Navigator.of(context).pop();})],
                                  );
                                },
                              );
                            },
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
    );
  }
}
