import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/providers/auth_provider.dart';

enum AuthType { SingUp, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthType _authType = AuthType.Login;

  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  /// Retorna se o Formulario está configurado para o Login
  bool get _isLogin => _authType == AuthType.Login;

  /// Retorna se o Formulario está configurado para o Cadastro
  bool get _isSingUp => _authType == AuthType.SingUp;

  /// Altera o Tipo do Formulario entre Login e Cadastro
  void _swithAuthType() =>
      setState(() => _authType = _isLogin ? AuthType.SingUp : AuthType.Login);

  /// Metodo Responsavel por Submeter, (Validar e Obter os Dados) do Formualrio
  void _submit() async {
    final bool isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm) return;

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    AuthProvider _authProvider = Provider.of(context, listen: false);
    try {

      _isLogin
          ? await _authProvider.login(
              _authData["email"]!,
              _authData["password"]!,
            )
          : await _authProvider.singUp(
              _authData["email"]!,
              _authData["password"]!,
            );
    } on HttpExceptions catch (error) {
      // TODO: Implementar Tratamento de Erro
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin ? 310 : 400,
        width: mediaQuery.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                validator: (_email) {
                  final email = _email ?? "";
                  if (email.trim().isEmpty) {
                    return "O Email Precisa ser Preenchido";
                  } else if (email.length < 8) {
                    return "O Email Precisa ter no Minimo 8 Caracteres";
                  } else if (!email.contains("@")) {
                    return "O Email Precisa conter '@'";
                  } else if (email.contains(" ")) {
                    return "O Email não pode conter Espaços em Branco";
                  } else {
                    return null;
                  }
                },
                onSaved: (emailValue) => _authData["email"] = emailValue ?? "",
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Senha"),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? "";
                  if (password.trim().isEmpty) {
                    return "A Senha Precisa ser Preenchida";
                  } else if (password.length < 8) {
                    return "A Senha Precisa ter no Minimo 8 Caracteres";
                  } else {
                    return null;
                  }
                },
                onSaved: (password) => _authData["password"] = password ?? "",
              ),
              if (_isSingUp)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Confirmar Senha"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _isLogin
                      ? null
                      : (_password) => _password != _passwordController.text
                          ? "A Senhas não são Iguais"
                          : null,
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _submit(),
                      child: Text(
                        _isLogin ? "ENTRAR" : "CADASTRAR",
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                    ),
              const Spacer(),
              TextButton(
                child: Text(
                  _isLogin ? "Realizar Cadastro" : "Realizar Login",
                ),
                onPressed: _swithAuthType,
              )
            ],
          ),
        ),
      ),
    );
  }
}
