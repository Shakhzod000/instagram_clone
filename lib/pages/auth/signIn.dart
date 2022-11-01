import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app1/pages/auth/signIn_provider.dart';
import 'package:instagram_clone_app1/utils/app_export.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static Widget get view => ChangeNotifierProvider(
    create: (_) => SignInProvider(),
    child: const SignInPage(),
  );
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

@override
void dispose(){
  context.read<SignInProvider>().Ondispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false, //? pixel errorda
      body: Consumer<SignInProvider>(
        builder: (context, signInProviderValue, _) => SafeArea(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Instagram',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
             const  SizedBox(
                height: 57,
              ),
              SizedBox(
                height: 44,
                width: 343,
                child: _cupertinoFiels(
                  controller: signInProviderValue.usernameController,
                  placeholder: 'username',
                ),
              ),
            const   SizedBox(
                height: 12,
              ),
               SizedBox(
                height: 44,
                width: 343,
                child: _cupertinoFiels(
                    controller: signInProviderValue.passwordController,
                    placeholder: 'password',
                    obscure: true),
              ),
            const   SizedBox(
                height: 19,
              ),
              SizedBox(
                width: 343,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {},
                      style: Theme.of(context).textButtonTheme.style,
                      child: const Text(
                        'forgot password?',
                      )),
                ),
              ),
            const   SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 343,
                height: 44,
                child: CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: .0),
                    onPressed: () => signInProviderValue.signIn(context),

                    child: signInProviderValue.isloading!
                    ? CupertinoActivityIndicator(
                      color: Theme.of(context).backgroundColor,
                    )
                    : const Text('Sig In')),
              ),
           const    SizedBox(
                height: 38.5,
              ),
              SizedBox(
                width: 170,
                height: 18,
                child: TextButton.icon(
                    icon:const  Icon(
                      Icons.facebook,
                      size: 17,
                    ),
                    onPressed: () {},
                    label: const Text('Log with Fasebook')),
              ),
             const  SizedBox(
                height: 41,
              ),
              SizedBox(
                width: 343,
                height: 18,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 1,
                      width: 132,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                    Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      height: 1,
                      width: 132,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ],
                ),
              ),
            const   SizedBox(
                height: 41.5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    child: const Text('Sign Up'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.signUpPage);
                    },
                  )
                ],
              ),
            ],
          ),
        )),
      ),
  floatingActionButton: FloatingActionButton(
        onPressed: () {
       AppUtils.themeChanger();
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 0.5, color: Theme.of(context).dividerColor))),
        height: 80,
        alignment: FractionalOffset.center,
        child: const Text('Instagram from Meta'),
      ),
    );

    
  }

  Widget _cupertinoFiels({
   required String? placeholder, required TextEditingController? controller, bool? obscure = false
  }){
    return CupertinoTextField(
      obscureText: obscure!,
      style: TextStyle(color: Theme.of(context).focusColor),
      controller: controller,
      placeholder: placeholder,
      placeholderStyle: Theme.of(context).inputDecorationTheme.hintStyle,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.8)
      ),
    );
  }
}