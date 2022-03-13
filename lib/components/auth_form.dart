import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/models/providers/auth_provider.dart';

enum AuthType { SingUp, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthType _authType = AuthType.Login;

  final Map<String, String> _authData = {
    AuthProvider.paramEmail: "",
    AuthProvider.paramPassword: "",
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
              _authData[AuthProvider.paramEmail]!,
              _authData[AuthProvider.paramPassword]!,
            )
          : await _authProvider.singUp(
              _authData[AuthProvider.paramEmail]!,
              _authData[AuthProvider.paramPassword]!,
            );
    } on AuthExceptions catch (error) {
      _showErrorDialog(error.getMessageError);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String massage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ocorreu um Erro"),
        content: Text(massage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
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
        width: mediaQuery.width * 0.85,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocus),
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
                onSaved: (emailValue) =>
                    _authData[AuthProvider.paramEmail] = emailValue ?? "",
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                focusNode: _passwordFocus,
                obscureText: true,
                onFieldSubmitted: (_) => _isLogin
                    ? _submit()
                    : FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocus),
                controller: _passwordController,
                textInputAction:
                    _isLogin ? TextInputAction.done : TextInputAction.next,
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
                onSaved: (password) =>
                    _authData[AuthProvider.paramPassword] = password ?? "",
              ),
              if (_isSingUp)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Confirmar Senha",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    focusNode: _confirmPasswordFocus,
                    obscureText: true,
                    onFieldSubmitted: (_) => _submit(),
                    validator: _isLogin
                        ? null
                        : (_password) => _password != _passwordController.text
                            ? "A Senhas não são Iguais"
                            : null,
                  ),
                ),
              const SizedBox(height: 8),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _submit(),
                        child: Text(
                          _isLogin ? "ENTRAR" : "CADASTRAR",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                    ),
              const SizedBox(height: 15),
              TextButton(
                child: Text(
                  _isLogin ? "Realizar Cadastro" : "Realizar Login",
                ),
                onPressed: _swithAuthType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
