import 'package:rxdart/rxdart.dart';
import '../models/searchable.dart';
import 'package:flutter_bootstrap/repository/repository.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

abstract class SearchableViewModel<B extends BeanSearchable, M extends ModelSearchable> {
  SearchableViewModel(this._repository, this._bean, {bool autoLoad=true}) {
    if (autoLoad) _firstQuery();
    _searchController.stream.debounce(Duration(milliseconds: 300)).listen((search) async {
      _resultsController.add(await filteratedData(search));
    });
  }

  static Injector injector = Injector.getInjector();
  final B _bean;
  final Repository _repository;
  final _searchController = PublishSubject<String>();
  final _resultsController = BehaviorSubject<List<M>>();
  Stream<List<M>> get resultList => _resultsController;
  Sink<String> get searchInput => _searchController.sink;

  Future<List<M>> filteratedData(String search) async =>
    (await _repository.fetchAll(search: search)).cast();

  void _firstQuery() async {
    _resultsController.add(await filteratedData(""));
  }

  void dispose() {
    _searchController.close();
    _resultsController.close();
  }
}