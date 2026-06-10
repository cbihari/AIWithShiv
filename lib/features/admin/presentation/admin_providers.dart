import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/firebase_admin_repository.dart';
import '../domain/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return FirebaseAdminRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
});
