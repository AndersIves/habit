import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/StudyInfo.dart';

class StudyInfoMapper extends CommonMapper<StudyInfo> {
  StudyInfoMapper._() : super(new StudyInfo());
  static StudyInfoMapper _instance = new StudyInfoMapper._();

  factory StudyInfoMapper() {
    return _instance;
  }
}
