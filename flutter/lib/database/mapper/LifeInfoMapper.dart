import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/LifeInfo.dart';

class LifeInfoMapper extends CommonMapper<LifeInfo> {
  LifeInfoMapper._() : super(new LifeInfo());
  static LifeInfoMapper _instance = new LifeInfoMapper._();

  factory LifeInfoMapper() {
    return _instance;
  }
}