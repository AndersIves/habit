import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/ScheduledExercise.dart';

class ScheduledExerciseMapper extends CommonMapper<ScheduledExercise> {
  ScheduledExerciseMapper._() : super(new ScheduledExercise());
  static ScheduledExerciseMapper _instance = new ScheduledExerciseMapper._();

  factory ScheduledExerciseMapper() {
    return _instance;
  }
}