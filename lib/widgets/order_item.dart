import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItemData;

  // ignore: use_key_in_widget_constructors
  const OrderItem(this.orderItemData);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _expanded
          ? min(widget.orderItemData.products.length * 40 + 110, 360)
          : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.orderItemData.amount}'),
              subtitle: Text(
                DateFormat('dd.MM.yyyy').format(widget.orderItemData.dateTime),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              height: _expanded
                  ? min(widget.orderItemData.products.length * 40 + 15, 180)
                  : 0,
              child: ListView(
                children: widget.orderItemData.products
                    .map(
                      (element) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                element.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${element.quantity} x\$ ${element.price}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
