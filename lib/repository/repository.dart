import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:jaguar_query/jaguar_query.dart';
import '../models/searchable.dart';
import '../models/restify.dart';
import '../services/api_service.dart';

abstract class Repository<
  M extends ModelRestify,
  B extends BeanSearchable<M>,
  R extends ApiService<M>
> {
  M mapItem(Map<String, dynamic> json);

  static Injector _injector = Injector.getInjector();
  final B _bean = _injector.get<B>();
  final R _resource = _injector.get<R>();

  Future<List<M>> fetchAll({String search=""}) async {
    List<M> list = (await (_bean as BeanSearchable).fetchSearch(search)).cast<M>();
    if ((list == null || list.length == 0) && search.length == 0) {
      final fetchData = await (_resource as ApiService).fetchAll();
      list = fetchData.map(mapItem);
      await (_bean as BeanSearchable).insertMany(list);
    }
    return list;
  }

  Future<M> fetch(int id) async {
    M model = await (_bean as BeanSearchable).find(id);
    if (model == null) {
      Map<String, dynamic> fetchData = await (_resource as ApiService).fetch(id);
      model = mapItem(fetchData);
      await (_bean as BeanSearchable).insertMany([model]);
    }
    return model;
  }
}