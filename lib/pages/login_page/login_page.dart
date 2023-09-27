import 'package:essapp/bloc/auth_bloc.dart';
import 'package:essapp/bloc/bloc_provider.dart';
import 'package:essapp/bloc/info_bloc.dart';
import 'package:essapp/pages/home_page/home_page.dart';
import 'package:essapp/widgets/custom_inputs/custom_text_field.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthBloc authBloc;
  late InfoBloc infoBloc;
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool hasErrorOnAuthentication = false;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    infoBloc = BlocProvider.of<InfoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                infoBloc.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Email",
                onChanged: (String? email){
                  authBloc.email = email;
                },
                validator: (String? email){
                  if((email?.length ?? 0) == 0){
                    return "Please enter your email";
                  }
                  else if(authBloc.validateEmail(email ?? "")){
                    return null;
                  }else{
                    return "Please enter valid email";
                  }
                },
              ),
              const SizedBox(height: 12.0),
              CustomTextField(
                label: "Password",
                onChanged: (String? password){
                  authBloc.password = password;
                },
                obscureText: !showPassword,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  onPressed: (){
                    toggleShowPassword();
                  },
                ),
                validator: (String? password){
                  if((password?.length ?? 0) == 0){
                    return "Please enter password";
                  }else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14.0),
              hasErrorOnAuthentication ? const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Invalid email or password",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent
                  ),
                ),
              ): const SizedBox(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: (){
                    if(formKey.currentState?.validate() ?? false){
                      if(authBloc.email?.trim() == "esssumon@gmail.com" && authBloc.password == "admin"){
                        Navigator.pushReplacementNamed(context, HomePage.routeName);
                      }else{
                        setState(() {
                          hasErrorOnAuthentication = true;
                        });
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  toggleShowPassword(){
    setState(() {
      showPassword = !showPassword;
    });
  }
}