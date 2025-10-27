import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vido/pages/controller/login_controller.dart';
import 'package:vido/pages/live_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      //背景图片
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/login_bg.png', fit: BoxFit.cover),
          ),
          _buildContent(context, controller),
        ],
      ),
    );
  }

  _buildContent(BuildContext context, LoginController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          _buildLoginImg(context),
          Expanded(child: _buildLoginForm(context, controller)),
        ],
      ),
    );
  }

  // 登录图片
  _buildLoginImg(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/login_laptop.png', width: 1003, height: 592),
      ],
    );
  }

  // 登录表单
  _buildLoginForm(BuildContext context, LoginController controller) {
    return Center(
      child: SizedBox(
        width: 460,
        height: 664,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Text(
                  'welcome_login'.tr,
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                Obx(() => _buildDropdownButton(controller)),
                // const Text(
                //   '中文',
                //   style: TextStyle(fontSize: 22, color: Color(0xFF969799)),
                // ),
              ],
            ),
            SizedBox(height: 74),
            _input('enter_username'.tr, controller.usernameController),
            SizedBox(height: 35),
            _input('enter_password'.tr, controller.passwordController, isPassword: true),
            SizedBox(height: 35),

            Row(
              children: [
                // _input('请输入验证码', width: 284),
                SizedBox(width: 16),
                Container(
                  height: 72,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 26),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: 1,
                  onChanged: (value) {
                    value = 0;
                  },
                ),
                Text(
                  'agree'.tr,
                  style: TextStyle(color: Color(0xFF969799), fontSize: 20),
                ),
                Text(
                  'user_agreement'.tr,
                  style: TextStyle(color: Color(0xFFE7525A), fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 74),
            InkWell(
              onTap: () async {
                await controller.login(context);
              },
              child: Container(
                height: 72,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFEA4159), // #EA4159
                      Color(0xFFE5655C), // #E5655C
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Center(
                  child: Text(
                    'login'.tr,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 输入框组件
  Widget _input(
    String hintText,
    TextEditingController controller, {
    bool isPassword = false,
    double width = 460,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 33, 33, 33),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 72,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white, fontSize: 22),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF969799), fontSize: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        ),
      ),
    );
  }
  Widget _buildDropdownButton(LoginController controller){
    return DropdownButton(
      dropdownColor: Color(0xFF1A1A1A),
      underline: null,
      value: controller.currentLocale,
      icon: const Icon(Icons.language, color: Colors.white,),
      items: LoginController.supportedLocales.map((locale) {
        String localeName = locale.languageCode == 'zh' ? '中文' : 'English';
        return DropdownMenuItem(
          value: locale,
          child: Text(localeName,style: TextStyle(color: Colors.white),),
        );
      }).toList(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          controller.updateLanguage(newLocale);
        }
      },
    );
  }
}
