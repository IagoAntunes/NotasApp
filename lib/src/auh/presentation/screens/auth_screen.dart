import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/core/utils/app_images.dart';
import 'package:notes_app/core/widgets/app_text_field.dart';
import 'package:notes_app/core/widgets/app_button.dart';
import 'package:notes_app/core/styles/app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.onRegisterTap,
    required this.onLoginTap,
    required this.isLoading,
  });

  final bool isLoading;
  final Function() onRegisterTap;
  final Function(String, String) onLoginTap;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _isBtnEnabled = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E6),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.logo,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(64),
                    topRight: Radius.circular(64),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Acesse suas notas salvas',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff8A8A8A),
                          ),
                        ),
                        SizedBox(height: 24),
                        AppTextField(
                          controller: _emailController,
                          label: 'E-mail',
                          hintText: 'seu@mail.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !widget.isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe seu e-mail';
                            }
                            if (value.contains('@') == false || value.contains('.') == false) {
                              return 'Informe um e-mail válido';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _isBtnEnabled.value = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
                          },
                        ),
                        SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          type: AppTextFieldType.password,
                          label: 'Senha',
                          hintText: 'Sua senha',
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          enabled: !widget.isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe sua senha';
                            }
                            if (value.length < 6) {
                              return 'A senha deve ter ao menos 6 caracteres';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _isBtnEnabled.value = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
                          },
                        ),
                        SizedBox(height: 32),
                        ValueListenableBuilder<bool>(
                          valueListenable: _isBtnEnabled,
                          builder: (context, value, child) {
                            return AppButton.primary(
                              isLoading: widget.isLoading,
                              enabled: _isBtnEnabled.value,
                              label: 'Acessar',
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  widget.onLoginTap(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        Spacer(),
                        Divider(),
                        Center(
                          child: GestureDetector(
                            onTap: widget.isLoading ? null : widget.onRegisterTap,
                            child: Text.rich(
                              TextSpan(
                                text: 'Não tem uma conta? ',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Criar Conta',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff242424),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
