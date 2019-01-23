import 'model.dart';
import 'searchable.dart';

abstract class ModelRestify extends ModelSearchable {
  String get restifyResourceUrl;
}