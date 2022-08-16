import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_model.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  // ignore: prefer_final_fields
  var _editedProudct = Product(
    id: null,
    description: '',
    imageUrl: '',
    price: 0,
    title: '',
  );
  var _isInit = true;
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final proctId = ModalRoute.of(context)?.settings.arguments;
      if (proctId != null) {
        _editedProudct = Provider.of<Products>(context, listen: false)
            .findById(proctId.toString());
        _initValues = {
          'title': _editedProudct.title,
          'description': _editedProudct.description,
          'price': _editedProudct.price.toString(),
          //'imageUrl': _editedProudct.imageUrl,
        };
        _imageUrlController.text = _editedProudct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_editedProudct.id != null) {
          await Provider.of<Products>(context, listen: false)
              .editProduct(_editedProudct.id!, _editedProudct);
        } else {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProudct);
        }
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                backgroundColor: Colors.grey,
                title: Text(
                  'Error!',
                  style: Theme.of(ctx).textTheme.headline4,
                ),
                content: const Text('Something went wrong!'),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            });
      }
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () => _saveForm(), icon: const Icon(Icons.save_alt))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProudct = Product(
                            id: _editedProudct.id,
                            title: value!,
                            description: _editedProudct.description,
                            imageUrl: _editedProudct.imageUrl,
                            price: _editedProudct.price,
                            isFavorite: _editedProudct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _form.currentState!.validate();
                        FocusScope.of(context)
                            .requestFocus(_discriptionFocusNode);
                      },
                      focusNode: _priceFocusNode,
                      onSaved: (value) {
                        _editedProudct = Product(
                          id: _editedProudct.id,
                          title: _editedProudct.title,
                          description: _editedProudct.description,
                          imageUrl: _editedProudct.imageUrl,
                          price: double.parse(value!),
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field can\'t be empty';
                        } else {
                          if (double.tryParse(value) != null) {
                            return null;
                          } else {
                            return 'Incorrect value';
                          }
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      focusNode: _discriptionFocusNode,
                      onSaved: (value) {
                        _editedProudct = Product(
                            id: _editedProudct.id,
                            title: _editedProudct.title,
                            description: value!,
                            imageUrl: _editedProudct.imageUrl,
                            price: _editedProudct.price,
                            isFavorite: _editedProudct.isFavorite);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Container(
                            child: _imageUrlController.text.isEmpty
                                ? const Center(child: Text('Enter URL'))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                              _saveForm();
                            },
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'U passed no image URL';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _editedProudct = Product(
                                  id: _editedProudct.id,
                                  title: _editedProudct.title,
                                  description: _editedProudct.description,
                                  imageUrl: value!,
                                  price: _editedProudct.price,
                                  isFavorite: _editedProudct.isFavorite);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
