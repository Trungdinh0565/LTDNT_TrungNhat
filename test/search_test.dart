import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:ltdnt_project/domain/meal_entity.dart';
import 'package:ltdnt_project/domain/meal_repository.dart';
import 'package:ltdnt_project/domain/meal_usecase/search.dart';

import 'search_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MealRepository>()])
void main() {
  late SearchMeals searchMeals;
  late MockMealRepository repository;

  setUp(() {
    repository = MockMealRepository();
    searchMeals = SearchMeals(repository);
  });

  final meal = MealEntity(
    id: '1',
    name: 'Chicken Rice',
    imageUrl: 'https://example.com/chicken-rice.jpg',
    instructions: 'Cook the rice and chicken',
    from: 'Vietnam',
  );

  test('Test1', () async {
    final result = await searchMeals('   ');

    expect(result, isEmpty);
    verifyNever(repository.search(any));
  });

  test('Test2', () async {
    final keyword = 'a' * 81;

    expect(
      searchMeals(keyword),
      throwsA(isA<ArgumentError>()),
    );

    verifyNever(repository.search(any));
  });

  test('Test3', () async {
    when(repository.search('chicken'))
        .thenAnswer((_) async => [meal]);

    final result = await searchMeals(' chicken ');

    expect(result, [meal]);
    verify(repository.search('chicken')).called(1);
  });
}