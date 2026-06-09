import 'package:basic_board/utils/imports.dart';

class AccountScreen extends ConsumerWidget {
  static String id = 'account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: EdgeInsets.only(top: ten),
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Delete account'),
            onTap: () {
              deleteAccountDialogue(context);
            },
          ),
        ],
      ),
    );
  }
}
