import '../view/login_view.dart';
import '../view/home_view.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';

  static final routes = {
    login: (context) => LoginView(),
    home: (context) => const HomeView(),
  };
}
