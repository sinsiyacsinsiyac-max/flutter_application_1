import 'package:flutter/material.dart';

class NotesDownloadPage extends StatelessWidget {
  const NotesDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notesList = [
      {'title': 'Computer Networks Notes', 'file': 'cn_notes.pdf'},
      {'title': 'Database Management Notes', 'file': 'dbms_notes.pdf'},
      {'title': 'Operating System Notes', 'file': 'os_notes.pdf'},
      {'title': 'Java Programming Notes', 'file': 'java_notes.pdf'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Download"),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notesList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading:
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
            title: Text(notesList[index]['title']!),
            trailing: const Icon(Icons.download, color: Colors.blue),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Downloading ${notesList[index]['file']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
