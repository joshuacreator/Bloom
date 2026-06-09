import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/direct_message_entity.dart';
import '../providers/direct_chat_providers.dart';
import 'direct_chat_screen.dart';

class DirectChatListScreen extends ConsumerWidget {
  final String userId;

  const DirectChatListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(directChatNotifierProvider(userId));

    ref.listen<AsyncValue<List<DirectMessageEntity>>>(
      directChatNotifierProvider(userId),
      (_, next) {
        next.whenOrNull(
          error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Direct Chats')),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (chats) {
          if (chats.isEmpty) {
            return const Center(child: Text('No direct chats yet'));
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                title: Text(chat.message),
                subtitle: Text(
                  chat.fromId == userId ? 'To: ${chat.toId}' : 'From: ${chat.fromId}',
                ),
                trailing: Text(
                  _formatTime(chat.time),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DirectChatScreen(chat: chat),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${time.month}/${time.day}';
  }
}
