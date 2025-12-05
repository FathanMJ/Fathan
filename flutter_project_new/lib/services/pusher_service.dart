import 'dart:async';
import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../config/pusher_config.dart';
import 'laravel_api_service.dart';

class PusherService {
  static PusherService? _instance;
  PusherChannelsFlutter? _pusher;
  PusherChannel? _currentChannel;

  // Callbacks
  Function(Map<String, dynamic>)? onMessage;
  Function(Map<String, dynamic>)? onRead;
  Function()? onConnected;
  Function()? onDisconnected;
  Function(dynamic)? onError;

  PusherService._internal();

  factory PusherService() {
    _instance ??= PusherService._internal();
    return _instance!;
  }

  /// Initialize Pusher connection
  Future<bool> initialize() async {
    try {
      if (_pusher != null) {
        print('✅ Pusher: Already initialized');
        return true;
      }

      _pusher = PusherChannelsFlutter.getInstance();
      
      // Get base URL untuk auth endpoint
      final baseUrl = LaravelApiService.baseUrl.replaceAll('/api', '');
      final authEndpoint = '$baseUrl/broadcasting/auth';
      
      print('🔧 Pusher: Configuring with authEndpoint: $authEndpoint');
      
      await _pusher!.init(
        apiKey: PusherConfig.appKey,
        cluster: PusherConfig.cluster,
        authEndpoint: authEndpoint,
        onConnectionStateChange: (currentState, previousState) {
          print('🔄 Pusher: Connection state changed from $previousState to $currentState');
          if (currentState == 'CONNECTED') {
            onConnected?.call();
          } else if (currentState == 'DISCONNECTED') {
            onDisconnected?.call();
          }
        },
        onError: (error, code, data) {
          print('❌ Pusher error: $error (code: $code)');
          onError?.call(error);
        },
        onSubscriptionSucceeded: (channelName, data) {
          print('✅ Pusher: Subscribed to $channelName');
        },
        onEvent: (event) {
          _handleEvent(event);
        },
        onSubscriptionError: (channelName, error) {
          print('❌ Pusher: Subscription error for $channelName: $error');
        },
        onDecryptionFailure: (event, reason) {
          print('❌ Pusher: Decryption failure: $reason');
        },
        onMemberAdded: (channelName, member) {
          print('👤 Pusher: Member added to $channelName');
        },
        onMemberRemoved: (channelName, member) {
          print('👤 Pusher: Member removed from $channelName');
        },
      );

      await _pusher!.connect();
      print('✅ Pusher: Initialized and connected');
      return true;
    } catch (e) {
      print('❌ Pusher initialization error: $e');
      onError?.call(e);
      return false;
    }
  }

  /// Connect to chat room channel
  Future<bool> connectToRoom(String roomId) async {
    try {
      if (_pusher == null) {
        final initialized = await initialize();
        if (!initialized) {
          return false;
        }
      }

      // Wait for connection
      int retries = 0;
      while (_pusher!.connectionState != 'CONNECTED' && retries < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }

      if (_pusher!.connectionState != 'CONNECTED') {
        print('❌ Pusher: Not connected after waiting');
        return false;
      }

      // Disconnect from previous channel
      await disconnectFromRoom();

      final channelName = 'private-chat-room.$roomId';
      
      print('🔌 Pusher: Subscribing to $channelName');
      
      // Subscribe to private channel
      // Pusher akan otomatis call auth endpoint untuk private channels
      // Auth endpoint sudah dikonfigurasi di init() dengan authEndpoint
      _currentChannel = await _pusher!.subscribe(
        channelName: channelName,
        onEvent: (event) {
          _handleEvent(event);
        },
        onSubscriptionSucceeded: (data) {
          print('✅ Pusher: Subscribed to $channelName');
        },
        onSubscriptionError: (error) {
          print('❌ Pusher: Subscription error: $error');
          onError?.call(error);
        },
      );

      print('✅ Pusher: Connected to room $roomId');
      return true;
    } catch (e) {
      print('❌ Pusher: Error connecting to room: $e');
      onError?.call(e);
      return false;
    }
  }

  /// Handle Pusher events
  void _handleEvent(PusherEvent event) {
    print('📨 Pusher: Received event ${event.eventName} on ${event.channelName}');
    
    switch (event.eventName) {
      case 'message.sent':
        try {
          final data = jsonDecode(event.data);
          onMessage?.call(data);
        } catch (e) {
          print('❌ Error parsing message.sent: $e');
        }
        break;
        
      case 'message.read':
        try {
          final data = jsonDecode(event.data);
          onRead?.call(data);
        } catch (e) {
          print('❌ Error parsing message.read: $e');
        }
        break;
        
      case 'pusher:subscription_succeeded':
        print('✅ Pusher: Subscription succeeded');
        break;
        
      case 'pusher:subscription_error':
        print('❌ Pusher: Subscription error');
        onError?.call(event.data);
        break;
        
      default:
        print('📨 Pusher: Unknown event ${event.eventName}');
    }
  }

  /// Disconnect from current room
  Future<void> disconnectFromRoom() async {
    try {
      if (_currentChannel != null) {
        await _pusher?.unsubscribe(channelName: _currentChannel!.channelName);
        _currentChannel = null;
        print('🔌 Pusher: Disconnected from room');
      }
    } catch (e) {
      print('❌ Pusher: Error disconnecting from room: $e');
    }
  }

  /// Disconnect Pusher completely
  Future<void> disconnect() async {
    try {
      await disconnectFromRoom();
      await _pusher?.disconnect();
      _pusher = null;
      print('🔌 Pusher: Disconnected');
    } catch (e) {
      print('❌ Pusher: Error disconnecting: $e');
    }
  }

  /// Check if connected
  bool get isConnected => _pusher?.connectionState == 'CONNECTED' && _currentChannel != null;
}
