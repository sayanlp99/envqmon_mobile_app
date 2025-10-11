import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/home_provider.dart';
import 'package:envqmon/presentation/providers/room_provider.dart';
import 'package:envqmon/presentation/widgets/app_button.dart';
import 'package:envqmon/presentation/widgets/app_text_field.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/presentation/widgets/error_dialog.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateRoom() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    if (authProvider.currentUser == null || authProvider.token == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Error',
          message: 'User not authenticated',
        ),
      );
      return;
    }

    final selectedHome = homeProvider.selectedHome;
    if (selectedHome == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Error',
          message: 'No home selected',
        ),
      );
      return;
    }

    final success = await roomProvider.createRoom(
      name: _nameController.text.trim(),
      homeId: selectedHome.homeId,
      userId: authProvider.currentUser!.userId,
      token: authProvider.token!,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted && roomProvider.error != null) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: 'Error',
          message: roomProvider.error!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          final selectedHome = homeProvider.selectedHome;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Icon(
                      Icons.room_outlined,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Add New Room',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedHome != null
                          ? 'Adding room to ${selectedHome.homeName}'
                          : 'Enter the details of your room',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Room Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter room name';
                        }
                        if (value.length < 2) {
                          return 'Room name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Consumer<RoomProvider>(
                      builder: (context, roomProvider, child) {
                        if (roomProvider.isLoading) {
                          return const LoadingIndicator(message: 'Creating room...');
                        }
                        return AppButton(
                          text: 'Create Room',
                          onPressed: _handleCreateRoom,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
