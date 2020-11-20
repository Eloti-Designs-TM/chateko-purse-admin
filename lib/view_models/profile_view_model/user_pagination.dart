import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/view_models/profile_view_model/profile_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPagination extends ProfileViewModel {
  final authApi = GetIt.I.get<AuthApi>();
  final userApi = GetIt.I.get<UserApi>();

  final scrollController = ScrollController();

  UsersPagination() {
    scrollController.addListener(scrollListener);
    fetchNextUsers();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (hasNext) {
        fetchNextUsers();
      }
    }
  }

  var usersSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Users> get users => usersSnapshot.map((snap) {
        return Users.fromDoc(snap);
      }).toList();

  Future fetchNextUsers() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;

    try {
      final snap = await userApi.getUsers(
        documentLimit,
        startAfter: usersSnapshot.isNotEmpty ? usersSnapshot.last : null,
      );
      usersSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }

  handleSearch(String query) async {
    final search =
        await userApi.usersRef.where('email', isLessThanOrEqualTo: query).get();
    usersSnapshot = search.docs;
    notifyListeners();
    print(search.docs);
    print(usersSnapshot);
  }
}
