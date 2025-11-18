import 'package:flutter/material.dart';

class PreviousQuestionPapersPage extends StatelessWidget {
  const PreviousQuestionPapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final papers = [
      {
        'title': 'BCA Semester 1 Question Papers (With Answers)',
        'file': 'bca_sem1_paper.pdf'
      },
      {
        'title': 'BCA Semester 2 Question Papers (With Answers)',
        'file': 'bca_sem2_paper.pdf'
      },
      {
        'title': 'BCA Semester 3 Question Papers (With Answers)',
        'file': 'bca_sem3_paper.pdf'
      },
      {
        'title': 'BCA Semester 4 Question Papers (With Answers)',
        'file': 'bca_sem4_paper.pdf'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Question Papers"),
        backgroundColor: Colors.purple,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: papers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading:
                const Icon(Icons.quiz_rounded, color: Colors.deepPurple),
            title: Text(papers[index]['title']!),
            trailing: const Icon(Icons.download, color: Colors.purple),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("Downloading ${papers[index]['file']}..."),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
