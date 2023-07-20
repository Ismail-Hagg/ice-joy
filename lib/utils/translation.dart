import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'email': 'Email Address',
          'password': 'Password',
          'forgot': 'fotgot password ?',
          'or': 'or',
          'login': 'Login',
          'no_account': 'Don\'t have an account ?',
          'signup_now': 'Sign Up Now',
        },
        'ar_SA': {
          'email': 'العنوان الالكتروني',
          'password': 'كلمة المرور',
          'forgot': 'نسيت كلمة المرور ؟',
          'or': 'او',
          'login': 'تسجيل الدخول',
          'no_account': 'ليس لديك حساب ؟',
          'signup_now': 'انشئ حسابك الان'
        }
      };
}
