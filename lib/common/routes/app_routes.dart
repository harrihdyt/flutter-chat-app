// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const Home = _Paths.Home;
  static const Auth = _Paths.Auth;
  static const Intro = _Paths.Intro;
  static const Profile = _Paths.Profile;
  static const ChatRoom = _Paths.ChatRoom;
  static const Search = _Paths.SearchView;
}

abstract class _Paths {
  static const Home = '/home';
  static const Auth = '/auth';
  static const Intro = '/intro';
  static const Profile = '/profile';
  static const ChatRoom = '/chatRoom';
  static const SearchView = '/search';
}
