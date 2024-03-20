import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/animated_status.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/network_image_box.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/add_user_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  void getUsers() {
    context.read<AuthBloc>().add(const GetUserEvent());
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UserCreatedState) {
          getUsers();
        } else if (state is UserCreatingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Bloc Clean Architecture & TDD"),
          ),
          body: state is AuthErrorState
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AnimatedStatus(height: 200, name: LottieName.kError),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.red[300],
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ))
              : state is GettingUserState
                  ? const Loader(message: "Getting users...")
                  : state is CreatingUserState
                      ? const Loader(message: "Creating users...")
                      : state is UserGotState
                          ? Center(
                              child: state.users.isEmpty
                                  ? const AnimatedStatus(
                                      name: LottieName.kEmpty, height: 300)
                                  : ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final user = state.users[index];
                                        return ListTile(
                                          leading: NetworkImageBox(
                                              url: user.avatar,
                                              height: 120,
                                              width: 120,
                                              radius: 15),
                                          title: Text(user.name),
                                          subtitle: Text(user.createdAt
                                              .toString()
                                              .substring(0, 10)),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10);
                                      },
                                      itemCount: state.users.length),
                            )
                          : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showAdaptiveDialog(
                  context: context,
                  builder: (context) => AddUserDialog(
                        nameController: nameController,
                      ));
            },
            icon: const Icon(Icons.add),
            label: const Text("Add User"),
          ),
        );
      },
    );
  }
}
