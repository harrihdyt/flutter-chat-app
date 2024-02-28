part of 'pages.dart';

class ChatRoomPage extends GetView<ChatRoomController> {
  ChatRoomPage({super.key});

  final authController = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];

  @override
  Widget build(BuildContext context) {
    bottomfield() {
      return Container(
        width: double.infinity,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: TextField(
                  controller: controller.chatC,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Enter typing'),
                ),
              ),
            ),
            IconButton(
              onPressed: () => controller.newChat(
                authController.user.value.email!,
                Get.arguments as Map<String, dynamic>,
                controller.chatC.text,
              ),
              icon: const Icon(
                Icons.send,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leadingWidth: 120,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: StreamBuilder<DocumentSnapshot<Object?>>(
                stream: controller.streamFriendData(
                    (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                builder: (context, snapFriendUser) {
                  if (snapFriendUser.connectionState ==
                      ConnectionState.active) {
                    var dataFriend =
                        snapFriendUser.data!.data() as Map<String, dynamic>;

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        dataFriend["photoUrl"],
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Icon(
                      Icons.person,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        centerTitle: false,
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: controller.streamFriendData(
              (Get.arguments as Map<String, dynamic>)["friendEmail"]),
          builder: (context, snapFriendUser) {
            if (snapFriendUser.connectionState == ConnectionState.active) {
              var dataFriend =
                  snapFriendUser.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataFriend["name"],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dataFriend["status"],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamChats(chat_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var alldata = snapshot.data!.docs;
                    Timer(
                      Duration.zero,
                      () => controller.scrollC
                          .jumpTo(controller.scrollC.position.maxScrollExtent),
                    );
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: controller.scrollC,
                      itemCount: alldata.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "${alldata[index]["groupTime"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ChatWidget(
                                message: "${alldata[index]["msg"]}",
                                isSender: alldata[index]["pengirim"] ==
                                        authController.user.value.email!
                                    ? true
                                    : false,
                                dateTime: "${alldata[index]["time"]}",
                              ),
                            ],
                          );
                        } else {
                          if (alldata[index]["groupTime"] ==
                              alldata[index - 1]["groupTime"]) {
                            return ChatWidget(
                              message: "${alldata[index]["msg"]}",
                              isSender: alldata[index]["pengirim"] ==
                                      authController.user.value.email!
                                  ? true
                                  : false,
                              dateTime: "${alldata[index]["time"]}",
                            );
                          } else {
                            return Column(
                              children: [
                                Text(
                                  "${alldata[index]["groupTime"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ChatWidget(
                                  message: "${alldata[index]["msg"]}",
                                  isSender: alldata[index]["pengirim"] ==
                                          authController.user.value.email!
                                      ? true
                                      : false,
                                  dateTime: "${alldata[index]["time"]}",
                                ),
                              ],
                            );
                          }
                        }
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomfield()),
        ],
      ),
    );
  }
}
