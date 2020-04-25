import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/database/entity/FoodInfo.dart';

class FoodInfoMapper extends CommonMapper<FoodInfo> {
  FoodInfoMapper._() : super(new FoodInfo());
  static FoodInfoMapper _instance = new FoodInfoMapper._();

  factory FoodInfoMapper() {
    return _instance;
  }
}