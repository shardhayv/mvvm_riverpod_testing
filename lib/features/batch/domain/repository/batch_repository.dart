import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_and_api_for_class/core/failure/failure.dart';
import 'package:hive_and_api_for_class/features/batch/data/repository/batch_remote_repo_impl.dart';
import 'package:hive_and_api_for_class/features/batch/domain/entity/batch_entity.dart';

final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  return ref.watch(batchRemoteRepoProvider);
  // // Check for the internet
  // final internetStatus = ref.watch(connectivityStatusProvider);

  // if (ConnectivityStatus.isConnected == internetStatus) {
  //   // If internet is available then return remote repo
  //   return ref.watch(batchRemoteRepoProvider);
  // } else {
  //   // If internet is not available then return local repo
  //   return ref.watch(batchLocalRepoProvider);
  // }
});

abstract class IBatchRepository {
  Future<Either<Failure, List<BatchEntity>>> getAllBatches();
  Future<Either<Failure, bool>> addBatch(BatchEntity batch);
}
