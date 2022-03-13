import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/models/providers/auth_provider.dart';

enum AuthType { singUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthType _authType = AuthType.login;
  bool _isLoading = false;

  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  /// Map Contendo os Valores de Login/Cadastro
  final Map<String, String> _authData = {
    AuthProvider.paramEmail: "",
    AuthProvider.paramPassword: "",
  };

  /// Retorna se o Formulario está configurado para o login
  bool get _isLogin => _authType == AuthType.login;

  /// Altera o Tipo do Formulario entre login e Cadastro
  void _swithAuthType() => setState(() {
        if (_isLogin) {
          _authType = AuthType.singUp;
          _animationController?.forward();
        } else {
          _authType = AuthType.login;
          _animationController?.reverse();
        }
      });

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
    final _mediaQuerySize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: _mediaQuerySize.width * 0.85,
        child: Form(
          key: _formKey,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
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
                  validator: _isValidEmail,
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
                  validator: _isValidPassword,
                  onSaved: (password) =>
                      _authData[AuthProvider.paramPassword] = password ?? "",
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _isLogin ? 0 : 60,
                    maxHeight: _isLogin ? 0 : 120,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: Padding(
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
                            : (_password) =>
                                _password != _passwordController.text
                                    ? "A Senhas não são Iguais"
                                    : null,
                      ),
                    ),
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
                    _isLogin ? "Realizar Cadastro" : "Realizar login",
                  ),
                  onPressed: _swithAuthType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Metodo Responsavel por Validar o Email conforme os Requisitos
  String? _isValidEmail(String? _email) {
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
  }

  /// Metodo Responsavel por Validar a Senha conforme os Requisitos
  String? _isValidPassword(String? _password) {
    final password = _password ?? "";
    if (password.trim().isEmpty) {
      return "A Senha Precisa ser Preenchida";
    } else if (password.length < 8) {
      return "A Senha Precisa ter no Minimo 8 Caracteres";
    } else {
      return null;
    }
  }
}
