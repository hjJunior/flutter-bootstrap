import 'package:flutter/material.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'model.dart';

abstract class ModelSearchable extends Model {
  Widget get searchElement;
  String get searchText => "$id";
}

abstract class BeanSearchable<T extends ModelSearchable> extends Bean<T> {
  BeanSearchable(Adapter adapter) : super(adapter);

  Future<List<T>> fetchSearch(String search);
  Future<void> insertMany(List<T> models, {bool cascade: false});
  Future<dynamic> insert(T model, {bool cascade: false, bool onlyNonNull: false, Set<String> only});
  Future<dynamic> upsert(T model, {bool cascade: false, Set<String> only, bool onlyNonNull: false});
  Future<T> find(int id, {bool preload: false, bool cascade: false});
}
