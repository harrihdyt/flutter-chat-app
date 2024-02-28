// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_is_empty, prefer_typing_uninitialized_variables, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/common/routes/app_pages.dart';
import 'package:flutter_chat_app/module_auth/data/models/chat_model.dart';
import 'package:flutter_chat_app/module_auth/data/models/user_model.dart';
import 'package:flutter_chat_app/module_auth/domain/entities/chat_entity.dart';
import 'package:flutter_chat_app/module_home/data/models/user_chat_model.dart';
import 'package:flutter_chat_app/module_home/domain/entities/user_chat_entity.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isSkip = false.obs;
  var isLogin = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? currentUser;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UserCredential? userCredential;
  var user = UserModel().obs;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) async {
      if (value) {
        await _googleSignIn
            .signInSilently()
            .then((value) => currentUser = value);

        final auth = await currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        );

        print(userCredential?.user);

        FirebaseAuth.instance.signInWithCredential(credential);

        CollectionReference collectionReference =
            firebaseFirestore.collection('users');

        collectionReference.doc(currentUser?.email).update({
          'createdAt':
              userCredential?.user?.metadata.creationTime?.toIso8601String(),
        });

        final users = await collectionReference.doc(currentUser!.email).get();

        final userData = users.data() as Map<String, dynamic>;

        user(UserModel(
          uid: userData["uid"],
          name: userData["name"],
          email: userData["email"],
          photoUrl: userData["photoUrl"],
          status: userData["status"],
          createdAt: userData["createdAt"],
        ));

        isLogin.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkip.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    // kita akan mengubah isSkipIntro => true
    SharedPreferences pref = await SharedPreferences.getInstance();

    var isSkipOnboard = pref.getBool('isSkip');

    if (isSkipOnboard != null || isSkipOnboard == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => currentUser = value);
        final googleAuth = await currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("USER CREDENTIAL");
        print(userCredential);

        // masukan data ke firebase...
        CollectionReference users = firebaseFirestore.collection('users');

        await users.doc(currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<UserChatEntity> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(UserChatModel(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              totalUnread: dataDocChat["total_unread"],
            ));
          });

          user.update((user) {
            user!.chatEntity = dataListChats.cast<ChatEntity>();
          });
        } else {
          user.update((user) {
            user!.chatEntity = [];
          });
        }

        user.refresh();

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> login() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      await _googleSignIn.signOut();

      await _googleSignIn.signIn().then((value) => currentUser = value);

      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        final auth = await currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        );

        print(userCredential?.user);

        FirebaseAuth.instance.signInWithCredential(credential);

        pref.setBool('isSkip', true);

        CollectionReference collectionReference =
            firebaseFirestore.collection('users');

        final userValidate =
            await collectionReference.doc(currentUser!.email).get();

        if (userValidate.data() == null) {
          await collectionReference.doc(currentUser?.email).set({
            'uid': userCredential?.user?.uid,
            'name': currentUser?.displayName,
            'email': currentUser?.email,
            'photoUrl': currentUser?.photoUrl,
            'status': ' ',
            'createdAt':
                userCredential?.user?.metadata.creationTime?.toIso8601String(),
            'keyName': currentUser!.displayName!.substring(0, 1).toUpperCase(),
            'chat': [],
          });
        } else {
          await collectionReference.doc(currentUser?.email).update({
            'createdAt':
                userCredential?.user?.metadata.creationTime?.toIso8601String(),
          });
        }

        final users = await collectionReference.doc(currentUser!.email).get();

        final userData = users.data() as Map<String, dynamic>;

        user(UserModel.fromJson(userData));

        isLogin.value = true;
        Get.offAllNamed(AppRoutes.Home);
      } else {
        print('failed');
        print(userCredential!.user!.uid);
      }

      await _googleSignIn.isSignedIn();
    } catch (e) {
      print('Failed $e $currentUser');
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
    Get.offAllNamed(AppRoutes.Auth);
  }

  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    // ignore: non_constant_identifier_names
    var chat_id;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firebaseFirestore.collection("chats");
    CollectionReference users = firebaseFirestore.collection("users");

    final docChats =
        await users.doc(currentUser!.email).collection("chats").get();

    if (docChats.docs.length != 0) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.length != 0) {
        // sudah pernah buat koneksi dengan => friendEmail
        flagNewConnection = false;

        //chat_id from chats collection
        chat_id = checkConnection.docs[0].id;
      } else {
        // blm pernah buat koneksi dengan => friendEmail
        // buat koneksi ....
        flagNewConnection = true;
      }
    } else {
      // blm pernah chat dengan siapapun
      // buat koneksi ....
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      // cek dari chats collection => connections => mereka berdua...
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.length != 0) {
        // terdapat data chats (sudah ada koneksi antara mereka berdua)
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
            await users.doc(currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<UserChatEntity> dataListChats = List<UserChatEntity>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(UserChatModel(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              totalUnread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chatEntity = dataListChats.cast<ChatEntity>();
          });
        } else {
          user.update((user) {
            user!.chatEntity = [];
          });
        }

        chat_id = chatDataId;

        user.refresh();
      } else {
        // buat baru , mereka berdua benar2 belum ada koneksi
        final newChatDoc = await chats.add({
          "connections": [
            currentUser!.email,
            friendEmail,
          ],
        });

        // ignore: await_only_futures
        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats =
            await users.doc(currentUser!.email).collection("chats").get();

        // ignore: prefer_is_empty
        if (listChats.docs.length != 0) {
          List<UserChatEntity> dataListChats = List<UserChatEntity>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(UserChatEntity(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              totalUnread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chatEntity = dataListChats.cast<ChatEntity>();
          });
        } else {
          user.update((user) {
            user!.chatEntity = [];
          });
        }

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }

    print(chat_id);

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: currentUser!.email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(currentUser!.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(
      AppRoutes.ChatRoom,
      arguments: {
        "chat_id": "$chat_id",
        "friendEmail": friendEmail,
      },
    );
  }
}
