import 'package:agroautomated/testdata_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agroautomated/provider/user_provider.dart';
import 'package:agroautomated/models/user.dart';

class TestPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userController = ref.read(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<User>>(
          future: userController.fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final users = snapshot.data;

            if (users == null || users.isEmpty) {
              return Center(child: Text('No users found'));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Name: ${userData.firstName} ${userData.lastName}'),
                    Text('Email: ${userData.email}'),
                    Text('Address: ${userData.address}'),
                    // Add more fields as needed
                    ElevatedButton(
                      onPressed: () {
                        // Call the delete function when the button is pressed
                        userController.deleteUser(userData.userId);
                      },
                      child: Text('Delete'),
                    ),
                    Divider(), // Add a divider between each user

                    ElevatedButton(
                        onPressed: () {
                          //   printData();

                          print("----------------");

                          getSensorValuesWithDates(
                              "ImgK7HBzrLhoCm0xoWE2.txt", 'temperature');
                        },
                        child: Text('storage check'))
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
