import 'package:shared_preferences/shared_preferences.dart';
import 'package:tes/core/constants/app_constants.dart';

class FavouriteLocalDataSource {
  final SharedPreferences preferences;//acutal localstorage ko access krn lye

  FavouriteLocalDataSource({
    required this.preferences,
  });

  static const String favouriteKey = 'favourite_products';//products ko key ke andr save krna

  Future<List<int>> getFavouriteIds() async {
      final ids =
        preferences.getStringList(
          AppConstants.favouriteProductsKey,
        ) ??
        [];

    return ids
        .map((id) => int.parse(id))
        .toList();
  }

  Future<void> toggleFavourite(int productId) async {
    final ids = await getFavouriteIds();//local storage se current list acces 

    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }

    await preferences.setStringList(
      favouriteKey,
      ids.map((id) => id.toString()).toList(),
    );
  }
}