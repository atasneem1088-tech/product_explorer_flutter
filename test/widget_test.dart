import 'package:flutter_test/flutter_test.dart';

import 'package:tes/features/products/data/datasources/favourite_local_datasource.dart';
import 'package:tes/features/products/data/datasources/product_remote_datasource.dart';
import 'package:tes/features/products/data/repositories/product_repository_impl.dart';
import 'package:tes/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final repository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSource(dio: Dio()),
      localDataSource: FavouriteLocalDataSource(preferences: prefs),
    );

    await tester.pumpWidget(MyApp(productRepository: repository));

    expect(find.text('Product Explorer'), findsOneWidget);
  });
}