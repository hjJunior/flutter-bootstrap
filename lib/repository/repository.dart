import '../models/searchable.dart';
import '../models/restify.dart';
import '../services/api_service.dart';

abstract class Repository<
  M extends ModelRestify,
  B extends BeanSearchable<M>,
  R extends ApiService<M>
> {
  M mapItem(Map<String, dynamic> json);

  Repository(this._bean, this._resource);

  final B _bean;
  final R _resource;

  Future<List<M>> fetchAll({String search=""}) async {
    List<M> list = (await (_bean as BeanSearchable).fetchSearch(search)).cast<M>();
    if ((list == null || list.length == 0) && search.length == 0) {
      final fetchData = await (_resource as ApiService).fetchAll();
      list = fetchData.map(mapItem).toList();
      for (final item in list) {
        final id = await (_bean as BeanSearchable).insert(item);
        item.id = id;
      }
    }
    return list;
  }

  Future<M> fetch(int id) async {
    M model = await _bean.find(id);

    if (model == null) {
      Map<String, dynamic> fetchData = await _resource.fetch(id);
      model = mapItem(fetchData);
      await _bean.insert(model);
      return model;
    }
    return model;
  }
}