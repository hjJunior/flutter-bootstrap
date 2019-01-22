import 'package:jaguar_orm/jaguar_orm.dart';

abstract class Model {
  @PrimaryKey(auto: true)
  int id;
}