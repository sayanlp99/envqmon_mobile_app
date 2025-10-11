import 'package:flutter/foundation.dart';
import 'package:envqmon/data/models/room_model.dart';
import 'package:envqmon/data/repositories/room_repository.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepository;

  RoomProvider({required RoomRepository roomRepository}) : _roomRepository = roomRepository;

  bool _isLoading = false;
  String? _error;
  List<RoomModel> _rooms = [];
  RoomModel? _selectedRoom;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<RoomModel> get rooms => _rooms;
  RoomModel? get selectedRoom => _selectedRoom;

  Future<void> loadRooms(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rooms = await _roomRepository.getRooms(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRoom({
    required String name,
    required String homeId,
    required String userId,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newRoom = await _roomRepository.createRoom(
        name: name,
        homeId: homeId,
        userId: userId,
        token: token,
      );
      
      _rooms.add(newRoom);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  List<RoomModel> getRoomsByHome(String homeId) {
    return _rooms.where((room) => room.homeId == homeId).toList();
  }

  void selectRoom(RoomModel room) {
    _selectedRoom = room;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
