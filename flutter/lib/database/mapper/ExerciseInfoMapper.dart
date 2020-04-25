import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/ExerciseInfo.dart';

class ExerciseInfoMapper extends CommonMapper<ExerciseInfo> {
  ExerciseInfoMapper._() : super(new ExerciseInfo());
  static ExerciseInfoMapper _instance = new ExerciseInfoMapper._();

  factory ExerciseInfoMapper() {
    return _instance;
  }
}