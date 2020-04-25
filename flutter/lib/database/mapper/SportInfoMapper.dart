
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/SportInfo.dart';

class SportInfoMapper extends CommonMapper<SportInfo> {
  SportInfoMapper._() : super(new SportInfo());
  static SportInfoMapper _instance = new SportInfoMapper._();

  factory SportInfoMapper() {
    return _instance;
  }
}