import 'package:shared_preferences/shared_preferences.dart';

/// @desc 用来做shared_preferences的存储
/// @time 2019-05-21 17:12
/// @author Cheney
class SpUtil {
  SpUtil._internal();
  static SpUtil _spUtils = SpUtil._internal();

  static SharedPreferences _spf;
  factory SpUtil() {
    return _spUtils;
  }

  ///初始化，必须要初始化
  Future<SharedPreferences> init() async {
    print('SharedPreferences初始化');
    _spf = await SharedPreferences.getInstance();
    return _spf;
  }

  static bool _beforeCheck() {
    if (_spf == null) {
      return true;
    }
    return false;
  }

  /// 判断是否存在数据
  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    if (_beforeCheck()) return null;
    return _spf.getKeys();
  }

  get(String key) {
    if (_beforeCheck()) return null;
    return _spf.get(key);
  }

  ///获取key对应的String类型值
  getString(String key) {
    if (_beforeCheck()) return null;
    return _spf.getString(key);
  }

  ///储存key对应的String类型值
  Future<bool> putString(String key, String value) {
    if (_beforeCheck()) return null;
    return _spf.setString(key, value);
  }

  ///获取key对应的bool类型值
  bool getBool(String key) {
    if (_beforeCheck()) return null;
    return _spf.getBool(key);
  }

  ///储存key对应的bool类型值
  Future<bool> putBool(String key, bool value) {
    if (_beforeCheck()) return null;
    return _spf.setBool(key, value);
  }

  ///获取key对应的int类型值
  int getInt(String key) {
    if (_beforeCheck()) return null;
    return _spf.getInt(key);
  }

  ///储存key对应的int类型值
  Future<bool> putInt(String key, int value) {
    if (_beforeCheck()) return null;
    return _spf.setInt(key, value);
  }

  ///获取key对应的double类型值
  double getDouble(String key) {
    if (_beforeCheck()) return null;
    return _spf.getDouble(key);
  }

  ///储存key对应的double类型值
  Future<bool> putDouble(String key, double value) {
    if (_beforeCheck()) return null;
    return _spf.setDouble(key, value);
  }

  ///获取key对应的List<String>类型值
  List<String> getStringList(String key) {
    return _spf.getStringList(key);
  }

  ///储存key对应的List<String>类型值
  Future<bool> putStringList(String key, List<String> value) {
    if (_beforeCheck()) return null;

    return _spf.setStringList(key, value);
  }

  ///获取key对应的dynamic类型值
  dynamic getDynamic(String key) {
    if (_beforeCheck()) return null;
    return _spf.get(key);
  }

  ///删除指定key对应的值
  Future<bool> remove(String key) {
    if (_beforeCheck()) return null;
    return _spf.remove(key);
  }

  ///清除所有的值
  Future<bool> clear() {
    if (_beforeCheck()) return null;
    return _spf.clear();
  }
}
