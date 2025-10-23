import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/app_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final DatabaseReference _ref;
  Stream<DatabaseEvent>? _stream;
  List<AppNotification> _items = <AppNotification>[];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _ref = FirebaseDatabase.instance.ref('users/${user.uid}/notifications');
      _stream = _ref.orderByChild('timestampMs').onValue;
      _stream!.listen((event) {
        final data = event.snapshot.value;
        final List<AppNotification> next = <AppNotification>[];
        if (data is Map) {
          data.forEach((key, value) {
            next.add(
              AppNotification.fromMap(
                key as String,
                Map<dynamic, dynamic>.from(value as Map),
              ),
            );
          });
          next.sort((a, b) => b.timestampMs.compareTo(a.timestampMs));
        }
        setState(() => _items = next);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Notifikasi', style: TextStyle(color: Colors.black)),
        elevation: 0.5,
      ),
      body: _items.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final m = _items[index];
                final title = m.title.isEmpty ? 'Tanpa Judul' : m.title;
                final body = m.body;
                return ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.black87,
                  ),
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  onTap: () {},
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.black26,
            ),
            SizedBox(height: 12),
            Text(
              'Belum ada notifikasi',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
