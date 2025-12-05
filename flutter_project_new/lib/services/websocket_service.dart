import 'dart:async';
import 'pusher_service.dart';

/// WebSocket Service menggunakan Pusher
///
/// Service ini menggunakan PusherService untuk koneksi realtime.
/// Untuk backward compatibility, service ini masih menggunakan nama WebSocketService.
class WebSocketService {
  static WebSocketService? _instance;
  PusherService? _pusherService;
  String? _currentRoomId;

  // Callbacks (delegated ke PusherService)
  Function(Map<String, dynamic>)? onMessage;
  Function(Map<String, dynamic>)? onRead;
  Function()? onConnected;
  Function()? onDisconnected;
  Function(dynamic)? onError;

  WebSocketService._internal() {
    _pusherService = PusherService();

    // Forward callbacks ke PusherService
    _pusherService!.onMessage = (data) => onMessage?.call(data);
    _pusherService!.onRead = (data) => onRead?.call(data);
    _pusherService!.onConnected = () => onConnected?.call();
    _pusherService!.onDisconnected = () => onDisconnected?.call();
    _pusherService!.onError = (error) => onError?.call(error);
  }

  factory WebSocketService() {
    _instance ??= WebSocketService._internal();
    return _instance!;
  }

  /// Connect to WebSocket server (menggunakan Pusher)
  Future<bool> connect(String roomId) async {
    try {
      if (_currentRoomId == roomId && _pusherService?.isConnected == true) {
        print('✅ WebSocket: Already connected to room $roomId');
        return true;
      }

      _currentRoomId = roomId;

      // Initialize Pusher jika belum
      if (_pusherService == null) {
        _pusherService = PusherService();
        _pusherService!.onMessage = (data) => onMessage?.call(data);
        _pusherService!.onRead = (data) => onRead?.call(data);
        _pusherService!.onConnected = () => onConnected?.call();
        _pusherService!.onDisconnected = () => onDisconnected?.call();
        _pusherService!.onError = (error) => onError?.call(error);
      }

      // Connect to room
      final success = await _pusherService!.connectToRoom(roomId);

      if (success) {
        print('✅ WebSocket: Connected to room $roomId via Pusher');
      }

      return success;
    } catch (e) {
      print('❌ WebSocket connection error: $e');
      onError?.call(e);
      return false;
    }
  }

  /// Send message via WebSocket (optional, usually sent via HTTP API)
  void sendMessage(String message) {
    // Pusher tidak support client-to-client messaging langsung
    // Gunakan HTTP API untuk mengirim pesan
    print('ℹ️ WebSocket: Use HTTP API to send messages, not WebSocket');
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    try {
      await _pusherService?.disconnect();
      _currentRoomId = null;
      print('🔌 WebSocket: Disconnected');
    } catch (e) {
      print('❌ WebSocket: Error disconnecting: $e');
    }
  }

  /// Check if connected
  bool get isConnected => _pusherService?.isConnected ?? false;
}
