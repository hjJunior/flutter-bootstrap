import 'dart:convert';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_bootstrap/consts.dart';
import 'package:flutter_bootstrap/models/restify.dart';
import 'package:jaguar_query/src/adapter/adapter.dart';
import 'package:jaguar_query/src/core/core.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bootstrap/services/api_service.dart';
import 'package:flutter_bootstrap/services/api_service.dart';
import 'package:flutter_bootstrap/repository/repository.dart';
import 'package:flutter_bootstrap/models/searchable.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class User extends ModelRestify {
  User();
  User.fromJSON(Map<String, dynamic> json) : id = 1;

  int id;

  @override
  String get restifyResourceUrl => '/somepath';

  @override
  // TODO: implement searchElement
  Widget get searchElement => null;
}

class UserBean extends BeanSearchable<User> {
  UserBean(Adapter adapter) : super(adapter);

  @override
  Future<List<User>> fetchSearch(String search) {
    // TODO: implement fetchSearch
    return Future.value([User.fromJSON({"id": 1})]);
  }

  @override
  Future<User> find(int id, {bool preload = false, bool cascade = false}) {
    // TODO: implement find
    return null;
  }

  @override
  Future<void> insertMany(List<User> models, {bool cascade = false}) {
    // TODO: implement insertMany
    return null;
  }

  @override
  // TODO: implement fields
  Map<String, Field> get fields => null;

  @override
  User fromMap(Map map) {
    // TODO: implement fromMap
    return null;
  }

  @override
  // TODO: implement tableName
  String get tableName => null;

  @override
  List<SetColumn> toSetColumns(User model, {bool update = false, Set<String> only}) {
    // TODO: implement toSetColumns
    return null;
  }
}

class UserResource extends ApiService<User> {
  UserResource() : super(User());
}

class UserRepository extends Repository<User, UserBean, UserResource> {
  @override
  User mapItem(Map<String, dynamic> json) {
    return User.fromJSON(json);
  }
}

class MockUserResource extends Mock implements UserResource {}

void main() {
  setUpAll(() {
    final injector = Injector.getInjector();

    MockFlutterSecureStorage fss = MockFlutterSecureStorage();
    MockUserResource userResource = MockUserResource();
    when(fss.read(key: kBaseUrl)).thenAnswer((_) => Future.value('http://www.google.com'));
    when(fss.read(key: kSecureStorageUserToken)).thenAnswer((_) => Future.value('token'));

    Client client = MockClient((request) async {
      return Response(json.encode([{"key": "value"}]), 200);
    });

    injector.map<Client>((i) => client);
    injector.map<FlutterSecureStorage>((i) => fss);
    injector.map<UserResource>((i) => UserResource());
    injector.map<UserBean>((i) => UserBean(null));
  });

  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  group('Service layer', () {
    test("fetchAll", () async {
      final subject = await ApiService<User>(User()).fetchAll();
      expect(subject, [{"key": "value"}]);
    });

    test("fetch", () async {
      final subject = await ApiService<User>(User()).fetchAll();
      expect(subject, [{"key": "value"}]);
    });
  });

  group("Repository", () {
    test("it works", () async {
      UserRepository userRepository = UserRepository();

      final users = await userRepository.fetchAll();
      expect(users.first.id, 1);
    });
  });
}
