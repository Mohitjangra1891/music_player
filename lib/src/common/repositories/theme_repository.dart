
import '../../utils/themes/themes.dart';

class ThemeRepository {
 static Future<void> updateTheme(String themeName) async {
   print("updating thme");
   print("updating thme");
   print("updating thme");
   print("updating thme");
   print("updating thme");
    await Themes.setTheme(themeName);
  }
}
