import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Dismiss the dialog when tapped outside
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      context.read<AuthBloc>().add(
                            CreateUserEvent(
                              createdAt: DateTime.now().toString(),
                              name: name,
                              avatar: "",
                            ),
                          );
                      nameController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Create User"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
