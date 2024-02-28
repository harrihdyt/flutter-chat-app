// ignore_for_file: avoid_unnecessary_containers, unnecessary_string_interpolations

part of 'pages.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    header({
      required String name,
      required String img,
    }) {
      return Container(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.Profile);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(img),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
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
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.Search);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 8,
                ),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    content() {
      return Expanded(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.chatsStream(authController.user.value.email!),
          builder: (context, snapshot1) {
            if (snapshot1.connectionState == ConnectionState.active) {
              var listDocsChats = snapshot1.data!.docs;
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: listDocsChats.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller
                        .friendStream(listDocsChats[index]["connection"]),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState == ConnectionState.active) {
                        var data = snapshot2.data!.data();
                        return data!["status"] == ""
                            ? ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                onTap: () => controller.goToChatRoom(
                                  "${listDocsChats[index].id}",
                                  authController.user.value.email!,
                                  listDocsChats[index]["connection"],
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black26,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      "${data["photoUrl"]}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${data["name"]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing:
                                    listDocsChats[index]["total_unread"] == 0
                                        ? const SizedBox()
                                        : Chip(
                                            backgroundColor: Colors.red[900],
                                            label: Text(
                                              "${listDocsChats[index]["total_unread"]}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                              )
                            : ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                onTap: () => controller.goToChatRoom(
                                  "${listDocsChats[index].id}",
                                  authController.user.value.email!,
                                  listDocsChats[index]["connection"],
                                ),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.black26,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: data["photoUrl"] == "noimage"
                                        ? Image.asset(
                                            "assets/logo/noimage.png",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "${data["photoUrl"]}",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  "${data["name"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "${data["status"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing:
                                    listDocsChats[index]["total_unread"] == 0
                                        ? const SizedBox()
                                        : Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: Text(
                                              '${listDocsChats[index]["total_unread"]}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                // Chip(
                                //     backgroundColor: Colors.red[900],
                                //     label: Text(
                                //       "${listDocsChats[index]["total_unread"]}",
                                //       style: const TextStyle(
                                //           color: Colors.white),
                                //     ),
                                //   ),
                              );
                      }
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    },
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(
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
