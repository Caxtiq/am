import 'package:flutter/material.dart';

class BorrowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: 5, 
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.bookmark, color: Colors.pinkAccent),
              title: Text('Borrowed Book $index'),
              subtitle: Text('Due Date'),
              trailing: ElevatedButton(
                onPressed: () {
                },
                child: Text('Return'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}