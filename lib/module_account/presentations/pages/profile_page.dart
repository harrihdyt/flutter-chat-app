// ignore_for_file: avoid_unnecessary_containers

part of 'pages.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(
                onPressed: () => authController.logout(),
                img: '${authController.user.value.photoUrl}',
                name: '${authController.user.value.name}'),
            const SizedBox(
              height: 30,
            ),
            content(),
          ],
        ),
      ),
    );
  }
}

header(
    {required Function() onPressed,
    required String img,
    required String name}) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(img),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.logout,
          ),
        ),
      ],
    ),
  );
}

content() {
  return Expanded(
    child: Column(
      children: [
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.person,
          ),
          title: const Text(
            'Account',
          ),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.lock,
          ),
          title: const Text(
            'Privacy',
          ),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.lock_outline_rounded,
          ),
          title: const Text(
            'Term & Condition',
          ),
        ),
      ],
    ),
  );
}
