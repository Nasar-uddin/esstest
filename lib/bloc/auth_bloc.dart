import 'package:essapp/bloc/bloc_base.dart';

class AuthBloc extends BlocBase{
  String? email = "Yo man";
  String? password;
  
  bool validateEmail(String email){
    final bool isEmailValid = 
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
    return isEmailValid;
  }

  @override
  void dispose() {
    
  }
}