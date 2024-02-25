import 'package:dubz_creator/utils/main_layout.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DubzVerifyPage extends StatefulWidget {
  const DubzVerifyPage({Key? key}) : super(key: key);

  @override
  State<DubzVerifyPage> createState() => _DubzVerifyPageState();
}

class _DubzVerifyPageState extends State<DubzVerifyPage> {
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MainLayout()),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 1,
                vertical: 1,
              ),
              child: Text(
                '< Back',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
          ),          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Verify Customer Dubz Code",
                    style: TextStyle(
                      color: Config.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const Center(
                  child: Text(
                    "Please Enter 6-Digit Dubz Code From Customer Side",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Config.spaceBig,
                
                SizedBox(
                  width: Config.widthSize * 0.5,
                  
                  child: PinCodeTextField(
                  appContext: context, 
                  length: 6, 
                  onChanged: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 60,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: Config.primaryColor,
                    inactiveColor: Colors.grey[400],
                    selectedColor: Config.primaryColor,

                  ),

                  keyboardType: TextInputType.number,
                  autoFocus: true,
                  cursorColor: Config.primaryColor,
                  animationType: AnimationType.fade,
                  animationDuration: Duration(milliseconds: 100),
                  enableActiveFill: true,
                ),
                ),
                

                Config.spaceSmall,
                
                Center (
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/** 
class OTPForm extends StatelessWidget {
  const OTPForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 68,
            width: 64,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              onSaved: (pin1) {},
              decoration: const InputDecoration(hintText: 'X'),
              style: Theme.of(context).textTheme.headlineMedium,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

            ),
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              onSaved: (pin2) {},
              decoration: const InputDecoration(hintText: 'X'),
              style: Theme.of(context).textTheme.headlineMedium,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

            ),
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              onSaved: (pin3) {},
              decoration: const InputDecoration(hintText: 'X'),
              style: Theme.of(context).textTheme.headlineMedium,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

            ),
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              onSaved: (pin4) {},
              decoration: const InputDecoration(hintText: 'X'),
              style: Theme.of(context).textTheme.headlineMedium,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

            ),
          ),       
          SizedBox(
            height: 68,
            width: 64,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              onSaved: (pin5) {},
              decoration: const InputDecoration(hintText: 'X'),
              style: Theme.of(context).textTheme.headlineMedium,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

            ),
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              onSaved: (pin6) {},
              decoration: const InputDecoration(hintText: 'X'),
              style: Theme.of(context).textTheme.headlineMedium,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],

            ),
          ),   
        ],
      ),
    );
  }
}
*/