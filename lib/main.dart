import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

// Main Page in the app
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Ordering App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageOrderPage()),
                );
              },
              child: const Text('Manage Order Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QueryOrderPage()),
                );
              },
              child: const Text('Query Saved Orders'),
            ),
          ],
        ),
      ),
    );
  }
}

// Items in the database added manually
final List<Map<String, dynamic>> databaseItems = [
  {'name': 'Veg Pizza', 'cost': 8.99},
  {'name': 'Veggie Burger', 'cost': 5.99},
  {'name': 'italian Pasta', 'cost': 7.49},
  {'name': 'greek veg Salad', 'cost': 4.99},
  {'name': 'chicken Sandwich', 'cost': 3.99},
  {'name': 'chicken wings', 'cost': 9.99},
  {'name': 'sushi', 'cost': 3.99},
  {'name': 'tacos', 'cost': 8.99},
  {'name': 'burritos', 'cost': 11.99},
  {'name': 'quesedellas', 'cost': 10.99},
  {'name': 'nachos', 'cost': 4.99},
  {'name': 'firefries', 'cost': 9.99},
  {'name': 'plant tender', 'cost': 7.99},
  {'name': 'naan', 'cost': 1.99},
  {'name': 'roti', 'cost': 1.99},
  {'name': 'veg biryani', 'cost': 16.99},
  {'name': 'chicken dum biryani', 'cost': 22.99},
  {'name': 'veggie shawarma wrap', 'cost': 12.99},
  {'name': 'chicken shawarma wrap', 'cost': 15.99},
  {'name': 'mountain dew', 'cost': 0.99},

];

// thwe users data
List<Map<String, dynamic>> userOrderPlan = [];
List<Map<String, dynamic>> savedOrders = [];

// helping in order ot manage the orders
class ManageOrderPage extends StatefulWidget {
  const ManageOrderPage({Key? key}) : super(key: key);

  @override
  _ManageOrderPageState createState() => _ManageOrderPageState();
}

class _ManageOrderPageState extends State<ManageOrderPage> {
  double targetCost = 0.0;
  DateTime selectedDate = DateTime.now();

  void _addToOrder(Map<String, dynamic> item) {
    setState(() {
      userOrderPlan.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to your order plan!')),
    );
  }

  void _saveOrderPlan() {
    if (userOrderPlan.isNotEmpty) {
      final totalCost = userOrderPlan.fold(0.0, (sum, item) => sum + item['cost']);
      savedOrders.add({
        'date': selectedDate,
        'items': List.from(userOrderPlan),
        'totalCost': totalCost,
      });
      setState(() {
        userOrderPlan.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order plan saved successfully!')),
      );

      // will automatically be able to navigate back and forth of theHome Screen
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items in the order plan to save!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Order Plan')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Set Target Cost'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                targetCost = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Text('Select Date: ${selectedDate.toLocal()}'.split(' ')[0]),
          ),
          const Divider(),
          const Text(
            'Database Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: databaseItems.length,
              itemBuilder: (context, index) {
                final item = databaseItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('\$${item['cost'].toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final currentTotal =
                      userOrderPlan.fold(0.0, (sum, i) => sum + i['cost']);
                      if (currentTotal + item['cost'] <= targetCost) {
                        _addToOrder(item);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot exceed target cost!')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const Text(
            'Your Order Plan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userOrderPlan.length,
              itemBuilder: (context, index) {
                final orderItem = userOrderPlan[index];
                return ListTile(
                  title: Text(orderItem['name']),
                  subtitle: Text('\$${orderItem['cost'].toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _saveOrderPlan,
            child: const Text('Save Order Plan'),
          ),
        ],
      ),
    );
  }
}
// the roder query page
class QueryOrderPage extends StatefulWidget {
  const QueryOrderPage({Key? key}) : super(key: key);

  @override
  State<QueryOrderPage> createState() => _QueryOrderPageState();
}

class _QueryOrderPageState extends State<QueryOrderPage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> filteredOrders = [];

  void _searchByDate() {
    setState(() {
      filteredOrders = savedOrders.where((order) {
        return order['date'] == selectedDate;
      }).toList();
    });
  }

  double _calculateTotalCost(dynamic items) {
    // Explicitly cast items to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> itemList =
    List<Map<String, dynamic>>.from(items);
    return itemList.fold(0.0, (sum, item) => sum + item['cost']);
  }

  void _editOrder(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderPage(
          order: order,
          onUpdate: () {
            setState(() {}); // Refresh the UI after editing
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query Saved Orders')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Text('Select Date: ${selectedDate.toLocal()}'.split(' ')[0]),
          ),
          ElevatedButton(
            onPressed: _searchByDate,
            child: const Text('Search Orders'),
          ),
          const Divider(),
          const Text(
            'Orders Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(child: Text('No orders found.'))
                : ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final totalCost = _calculateTotalCost(order['items']);
                final orderDate = order['date']
                    .toLocal()
                    .toString()
                    .split(' ')[0]; // Format date

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ${index + 1}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Date: $orderDate', // Display the date
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Items:',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              for (var item in (order['items'] as List<dynamic>)
                                  .cast<Map<String, dynamic>>())
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0),
                                  child: Text(
                                    '- ${item['name']}: \$${item['cost'].toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'Total Cost: \$${totalCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editOrder(order),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// the Edit Order Page
class EditOrderPage extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback onUpdate;

  const EditOrderPage({Key? key, required this.order, required this.onUpdate})
      : super(key: key);

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}
class _EditOrderPageState extends State<EditOrderPage> {
  double totalCost = 0;
  late TextEditingController targetCostController;

  @override
  void initState() {
    super.initState();
    _calculateTotalCost();
    // Initialize the targetCostController with the saved target cost
    targetCostController = TextEditingController(
      text: widget.order['totalCost'].toStringAsFixed(2), // Use the saved targetCost
    );
  }

  @override
  void dispose() {
    // Dispose of the controller to free resources
    targetCostController.dispose();
    super.dispose();
  }

  void _calculateTotalCost() {
    totalCost = widget.order['items']
        .fold(0.0, (sum, item) => sum + (item['cost'] as double));
  }

  void _saveChanges() { //saving the changes
    final newTargetCost = double.tryParse(targetCostController.text);
    if (newTargetCost != null) {
      if (totalCost > newTargetCost) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Total cost exceeds the target cost!')),
        );
        return;
      }
      setState(() {
        widget.order['totalCost'] = newTargetCost; // Save the updated target cost
      });
    }
    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Order')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: targetCostController,
              decoration: const InputDecoration(labelText: 'Target Cost'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  // Ensure targetCostController reflects the intended value
                  widget.order['totalCost'] = double.tryParse(value) ?? totalCost;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.order['items'].length,
              itemBuilder: (context, index) {
                final item = widget.order['items'][index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Item Name:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cost:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${item['cost'].toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                widget.order['items'].removeAt(index);
                                _calculateTotalCost();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Item'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: databaseItems.length,
                        itemBuilder: (context, index) {
                          final item = databaseItems[index];
                          return ListTile(
                            title: Text(item['name']),
                            subtitle:
                            Text('\$${item['cost'].toStringAsFixed(2)}'),
                            onTap: () {
                              setState(() {
                                widget.order['items'].add({
                                  'name': item['name'],
                                  'cost': item['cost'],
                                });
                                _calculateTotalCost();
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Add Item'),
          ),
          const Divider(),
          Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
          ElevatedButton(
            onPressed: _saveChanges,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
