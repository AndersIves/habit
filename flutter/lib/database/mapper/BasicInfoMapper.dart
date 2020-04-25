import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/BasicInfo.dart';

class BasicInfoMapper extends CommonMapper<BasicInfo> {
  BasicInfoMapper._() : super(new BasicInfo());
  static BasicInfoMapper _instance = new BasicInfoMapper._();

  factory BasicInfoMapper() {
    return _instance;
  }
}