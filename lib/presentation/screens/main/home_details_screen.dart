import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/home_provider.dart';
import 'package:envqmon/presentation/providers/room_provider.dart';
import 'package:envqmon/presentation/screens/main/add_room_screen.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/core/constants/app_constants.dart';

class HomeDetailsScreen extends StatefulWidget {
  const HomeDetailsScreen({super.key});

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    if (authProvider.token != null) {
      await roomProvider.loadRooms(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, RoomProvider, HomeProvider>(
      builder: (context, authProvider, roomProvider, homeProvider, child) {
        final selectedHome = homeProvider.selectedHome;

        if (selectedHome == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home Details')),
            body: const Center(
              child: Text('No home selected'),
            ),
          );
        }

        final homeRooms = roomProvider.getRoomsByHome(selectedHome.homeId);

        return Scaffold(
          appBar: AppBar(
            title: Text(selectedHome.homeName),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                color: AppConstants.primaryColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedHome.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rooms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${homeRooms.length} room${homeRooms.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: roomProvider.isLoading
                    ? const LoadingIndicator(message: 'Loading rooms...')
                    : homeRooms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.room_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No rooms found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add your first room to this home',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const AddRoomScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Room'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            itemCount: homeRooms.length,
                            itemBuilder: (context, index) {
                              final room = homeRooms[index];
                              return Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppConstants.defaultPadding,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: AppConstants.secondaryColor,
                                    child: Icon(
                                      Icons.room,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    room.roomName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Room in ${selectedHome.homeName}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    roomProvider.selectRoom(room);
                                    // Navigate to room details or device list
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddRoomScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
