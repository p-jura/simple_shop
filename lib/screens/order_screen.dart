import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' as ord;

class OrderScreen extends StatefulWidget {
  static const routName = '/order-screen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;
  
  Future fetchDataFromProvider() {
    return Provider.of<ord.Orders>(context, listen: false).getAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = fetchDataFromProvider();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _ordersData = Provider.of<ord.Orders>(context).orders;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapszot) {
            return dataSnapszot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItem(_ordersData[index]);
                    },
                    itemCount: _ordersData.length,
                  );
          }),
    );
  }
}
