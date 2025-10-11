import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/home_provider.dart';
import 'package:envqmon/presentation/screens/main/home_details_screen.dart';
import 'package:envqmon/presentation/screens/main/add_home_screen.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/core/constants/app_constants.dart';

class HomesListScreen extends StatelessWidget {
  const HomesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Homes'),
        centerTitle: true,
      ),
      body: Consumer2<AuthProvider, HomeProvider>(
        builder: (context, authProvider, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const LoadingIndicator(message: 'Loading homes...');
          }

          if (homeProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${homeProvider.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      homeProvider.clearError();
                      if (authProvider.token != null) {
                        homeProvider.loadHomes(authProvider.token!);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (homeProvider.homes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No homes found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first home to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddHomeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Home'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: homeProvider.homes.length,
            itemBuilder: (context, index) {
              final home = homeProvider.homes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppConstants.primaryColor,
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    home.homeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    home.address,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    homeProvider.selectHome(home);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeDetailsScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddHomeScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
