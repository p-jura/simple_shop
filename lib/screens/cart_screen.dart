import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_Item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart-screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Spacer(),
                    Chip(
                      backgroundColor: Colors.purple,
                      label: Text('\$ ${cart.totalAmmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, count) {
                return CartItemList(
                  cartItemId: cart.items.values.toList()[count].id!,
                  productId: cart.items.keys.toList()[count],
                  price: cart.items.values.toList()[count].price,
                  quantity: cart.items.values.toList()[count].quantity,
                  title: cart.items.values.toList()[count].title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.itemCount <= 0
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmmount);

                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
                Navigator.of(context).pop();
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Error! Couldnt save order, try again later',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                setState(() {
                  _isLoading = false;
                });
                
              }
            },
      child: SizedBox(
        width: 80,
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(
                  'ORDER NOW',
                  style: widget.cart.itemCount <= 0
                      ? const TextStyle(color: Colors.grey, fontSize: 14)
                      : Theme.of(context).textTheme.headline4,
                ),
        ),
      ),
    );
  }
}
