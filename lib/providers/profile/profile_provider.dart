import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';

final userProvider = Provider<User>((ref) {
  return const User(
    id: 'user_1',
    name: 'David Amani',
    email: 'david@gmail.com',
    avatarUrl: 'https://avatars.githubusercontent.com/u/219689204?s=400&u=e1bcae8c69abf654b4c695989f62106459a55f30&v=4',
  );
});