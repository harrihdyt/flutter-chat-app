part of 'pages.dart';

class SearchViewPage extends GetView<SearchContactController> {
  SearchViewPage({super.key});

  final data = Get.find<AuthController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            130,
          ),
          child: AppBar(
              backgroundColor: Colors.green,
              title: const Text(
                'Search Chat',
              ),
              centerTitle: true,
              flexibleSpace: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          // controller: controller.searchController,
                          onChanged: (value) => controller.searchContact(
                              value, data.user.value.email!),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Search...',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: controller.tempSearch.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  authController
                      .addNewConnection(controller.tempSearch[index]["email"]);
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${controller.tempSearch[index]['photoUrl']}'),
                ),
                title: Text(
                  '${controller.tempSearch[index]['name']}',
                ),
                subtitle: Text(
                  '${controller.tempSearch[index]['email']}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ));
  }
}
