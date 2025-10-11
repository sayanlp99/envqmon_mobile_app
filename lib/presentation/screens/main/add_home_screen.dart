import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/home_provider.dart';
import 'package:envqmon/presentation/widgets/app_button.dart';
import 'package:envqmon/presentation/widgets/app_text_field.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/presentation/widgets/error_dialog.dart';

class AddHomeScreen extends StatefulWidget {
  const AddHomeScreen({super.key});

  @override
  State<AddHomeScreen> createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateHome() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

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

    final success = await homeProvider.createHome(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      userId: authProvider.currentUser!.userId,
      token: authProvider.token!,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted && homeProvider.error != null) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: 'Error',
          message: homeProvider.error!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Icon(
                  Icons.home_outlined,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Add New Home',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the details of your home',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                AppTextField(
                  controller: _nameController,
                  labelText: 'Home Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter home name';
                    }
                    if (value.length < 2) {
                      return 'Home name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _addressController,
                  labelText: 'Address',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    if (value.length < 5) {
                      return 'Address must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                    if (homeProvider.isLoading) {
                      return const LoadingIndicator(message: 'Creating home...');
                    }
                    return AppButton(
                      text: 'Create Home',
                      onPressed: _handleCreateHome,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
