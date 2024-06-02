import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/bg2.jpg",
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text("Vamana App" , style: TextStyle(color: Color(0xff15400D) , fontWeight: FontWeight.w900 , fontSize: 50),)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffcfe1b9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(label: Text("User Name") , border: OutlineInputBorder()),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(label: Text("Password") ,border: OutlineInputBorder()),
                      ),
                    ),

                    SizedBox(
                      width: screenWidth*0.85,
                      height: screenHeight*0.1,

                      child: Padding(
                        padding: const EdgeInsets.all(16), 
                        child: ElevatedButton(
                          
                          child: Text("Sign In" , style: TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.w600),),onPressed: (){},
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Color(0xff0f6f03))),
                          ),
                      ),
                    )
                  ],
                ),
                width: screenWidth*0.9,
                height: screenHeight*0.37,
              ),
              SizedBox(
                height: screenHeight*0.025,
              )
            ],
          )
        ],
      ),
    );
  }
}
