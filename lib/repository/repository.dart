import 'package:shared_preferences/shared_preferences.dart';

class CountRepository {
  String _key(int slot) => 'count_$slot';

  Future<void> saveCount(int slot, int count) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_key(slot), count);
  }

  Future<int> loadCount(int slot) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_key(slot)) ?? 0;
  }
}
