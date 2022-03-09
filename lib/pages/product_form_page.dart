import 'package:flutter/material.dart';
import 'package:shop/models/entities/product.dart';

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

  final Map<String, Object> _formData = {};

  /// Metodo que Iniciará os Itens Utilizados
  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
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

  /// Metodo Responsavel por Atualizar o Estado da Imagem
  /// a partir da atualização da Interface Grafica
  void _updateImage() {
    setState(() {});
  }

  /// Metodo Responsavel por controlar a Submição do Formulario
  void _submitForm() {
    // Obtem o Valor da Validação dos validator dos TextFormField
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      // Por meio da Key no Formulario, acessa a Informação Save de cada um
      _formKey.currentState?.save();

      final newProduct = Product(
        id: Product.generateIdItem,
        name: _formData["name"] as String,
        description: _formData["description"] as String,
        price: _formData["price"] as double,
        imageURL: _formData["imageUrl"] as String,
      );
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (nameValue) => _formData["name"] = nameValue ?? "",
                validator: (nameValue) => Product.validateName(nameValue),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Preço"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocus,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocus),
                textInputAction: TextInputAction.next,
                onSaved: (priceValue) {
                  _formData["price"] = double.parse(priceValue ?? "0");
                },
                validator: (priceValue) => Product.validatePrice(priceValue),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descrição"),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocus,
                onSaved: (descriptionValue) {
                  _formData["description"] = descriptionValue ?? "";
                },
                validator: (descriptionValue) =>
                    Product.validateDescription(descriptionValue),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Descrição"),
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      textInputAction: TextInputAction.done,
                      onSaved: (imageUrlValue) {
                        _formData["imageUrl"] = imageUrlValue ?? "";
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
