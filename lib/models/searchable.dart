import 'package:flutter/material.dart';
import 'model.dart';

abstract class ModelSearchable extends Model {
  Widget get searchElement => ListTile(
    title: Text("$id"),
  );
}

abstract class BeanSearchable<T extends ModelSearchable> {
  Future<List<T>> fetchSearch(String search);
}
