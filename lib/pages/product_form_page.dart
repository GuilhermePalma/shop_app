import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/loading_widget.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/products_provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Variavel que Controla a Animação durante a Chamada na API
  bool _isLoading = false;

  final Map<String, Object> _formData = {};

  /// Metodo que Iniciará os Itens Utilizados
  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final argumentProduct = ModalRoute.of(context)?.settings.arguments;

      if (argumentProduct != null) {
        final Product product = argumentProduct as Product;
        _formData[Product.paramID] = product.id;
        _formData[Product.paramName] = product.name;
        _formData[Product.paramDescription] = product.description;
        _formData[Product.paramPrice] = product.price;
        _formData[Product.paramImageURL] = product.imageURL;
        _imageUrlController.text = product.imageURL;
      }
    }
  }

  /// Metodo que "Libera" os Itens Utilizados
  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(_updateImage);
  }

  /// Metodo Responsavel por Atualizar o Estado da Imagem (Update all UI)
  void _updateImage() => setState(() {});

  /// Metodo Responsavel por controlar a Submição do Formulario
  Future<void> _submitForm() async {
    // Obtem o Valor da Validação dos validator dos TextFormField
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      // Por meio da Key no Formulario, acessa a Informação Save de cada um
      _formKey.currentState?.save();

      setState(() => _isLoading = true);

      try {
        // Provider fora do metodo Build (Por conta do Context), demanda o Listen = false
        // await = o codigo fica aguardando o resultado
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProductFromData(_formData);
        Navigator.of(context).pop();
      } on HttpExceptions catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Ocorreu um Erro"),
            content: Text(error.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop,
                child: const Text("Ok"),
              ),
            ],
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario de Produtos"),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData[Product.paramName]?.toString(),
                      decoration: const InputDecoration(labelText: "Nome"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (nameValue) =>
                          _formData[Product.paramName] = nameValue ?? "",
                      validator: (nameValue) => Product.validateName(nameValue),
                    ),
                    TextFormField(
                      initialValue: _formData[Product.paramPrice]?.toString(),
                      decoration: const InputDecoration(labelText: "Preço"),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocus,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      textInputAction: TextInputAction.next,
                      onSaved: (priceValue) {
                        _formData[Product.paramPrice] =
                            double.parse(priceValue ?? "0");
                      },
                      validator: (priceValue) =>
                          Product.validatePrice(priceValue),
                    ),
                    TextFormField(
                      initialValue:
                          _formData[Product.paramDescription]?.toString(),
                      decoration: const InputDecoration(labelText: "Descrição"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocus,
                      onSaved: (descriptionValue) {
                        _formData[Product.paramDescription] =
                            descriptionValue ?? "";
                      },
                      validator: (descriptionValue) =>
                          Product.validateDescription(descriptionValue),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "URL da Imagem"),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocus,
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            onSaved: (imageUrlValue) {
                              _formData[Product.paramImageURL] =
                                  imageUrlValue ?? "";
                            },
                            validator: (urlValue) =>
                                Product.validateImageURL(urlValue),
                            onFieldSubmitted: (_) => _submitForm(),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 20, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  "Informe a URL",
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
