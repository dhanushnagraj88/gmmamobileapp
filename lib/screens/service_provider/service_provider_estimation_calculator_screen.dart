import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/services_and_parts.dart';

class ServiceProviderEstimationCalculatorScreen extends StatefulWidget {
  const ServiceProviderEstimationCalculatorScreen({Key? key}) : super(key: key);

  static const routeName = '/service-provider-estimation-calculator-screen';

  @override
  State<ServiceProviderEstimationCalculatorScreen> createState() =>
      _ServiceProviderEstimationCalculatorScreenState();
}

class _ServiceProviderEstimationCalculatorScreenState
    extends State<ServiceProviderEstimationCalculatorScreen> {
  User? userData;
  DocumentSnapshot<Map<String, dynamic>>? collectionsData;
  final servicesListKey = GlobalKey<_ServicesListState>();
  final partsListKey = GlobalKey<_PartsListState>();

  Future<void> _getCurrentUserData() async {
    userData = FirebaseAuth.instance.currentUser;
    final collectionData = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(userData?.uid)
        .get();
    setState(() {
      collectionsData = collectionData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserData();
    super.initState();
  }

  int totalCost = 0;
  int totalDuration = 0;
  // ServicesList servicesList = const ServicesList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Estimate'),
      ),
      body: Column(
        children: [
          Card(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Services',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(Icons.design_services,
                    color: Theme.of(context).colorScheme.onPrimary, size: 25),
              ],
            ),
          ),
          Expanded(
            child: ServicesList(key: servicesListKey),
          ),
          Card(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Parts',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(Icons.inventory,
                    color: Theme.of(context).colorScheme.onPrimary, size: 25),
              ],
            ),
          ),
          Expanded(
            child: PartsList(key: partsListKey),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Cost: $totalCost',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Duration: $totalDuration',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final servicesListState =
                      servicesListKey.currentState as _ServicesListState;
                  final serviceCost = servicesListState.serviceCost;
                  final serviceDuration = servicesListState.serviceDuration;
                  final partsListState =
                      partsListKey.currentState as _PartsListState;
                  final partsCost = partsListState.partsCost;
                  final partsDuration = partsListState.partsDuration;
                  setState(() {
                    totalCost = serviceCost + partsCost;
                    totalDuration = serviceDuration + partsDuration;
                  });
                },
                child: const Text('Calculate Estimate'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ServicesList extends StatefulWidget {
  const ServicesList({Key? key}) : super(key: key);

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  List<Services> _listOfServices = [];

  void _addService({
    required String name,
    required String type,
    required int cost,
    required int duration,
  }) {
    _listOfServices.add(
      Services(
        serviceName: name,
        serviceType: type,
        serviceCost: cost,
        serviceDuration: duration,
      ),
    );
    for (var element in _listOfServices) {
      print(element.serviceName);
    }
  }

  void _removeService({
    required String name,
    required String type,
  }) {
    _listOfServices.removeWhere((element) =>
        (element.serviceName == name && element.serviceType == type));
    for (var element in _listOfServices) {
      print(element.serviceName);
    }
  }

  int get serviceCost {
    int cost = 0;
    for (var element in _listOfServices) {
      cost += element.serviceCost;
    }
    return cost;
  }

  int get serviceDuration {
    int duration = 0;
    for (var element in _listOfServices) {
      duration += element.serviceDuration;
    }
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('serviceProviders')
              .doc(futureSnapshot.data?.uid)
              .collection('servicesList')
              .orderBy(
                'dateAdded',
                descending: true,
              )
              .snapshots(),
          builder: (ctx, servicesSnapshot) {
            if (servicesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (servicesSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No services added yet'),
              );
            }
            final servicesDocs = servicesSnapshot.data!.docs;

            return ListView.builder(
              itemCount: servicesDocs.length,
              itemBuilder: (ctx, index) {
                return EstimateServicesItem(
                  servicesDocs: servicesDocs[index],
                  addServiceFunc: _addService,
                  removeServiceFunction: _removeService,
                );
              },
            );
          },
        );
      },
    );
  }
}

class EstimateServicesItem extends StatefulWidget {
  const EstimateServicesItem({
    Key? key,
    required this.servicesDocs,
    required this.addServiceFunc,
    required this.removeServiceFunction,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> servicesDocs;
  final void Function({
    required String name,
    required String type,
    required int cost,
    required int duration,
  }) addServiceFunc;
  final void Function({
    required String name,
    required String type,
  }) removeServiceFunction;

  @override
  State<EstimateServicesItem> createState() => _EstimateServicesItemState();
}

class _EstimateServicesItemState extends State<EstimateServicesItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        key: ValueKey(widget.servicesDocs),
        title: Text(
          widget.servicesDocs['serviceName'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.servicesDocs['serviceType'],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Cost: ${widget.servicesDocs['serviceCost']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Service Duration: ${widget.servicesDocs['serviceDuration']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
        value: _isSelected,
        onChanged: (bool? value) {
          setState(() {
            _isSelected = value!;
            if (_isSelected) {
              widget.addServiceFunc(
                name: widget.servicesDocs['serviceName'],
                type: widget.servicesDocs['serviceType'],
                duration: widget.servicesDocs['serviceDuration'],
                cost: widget.servicesDocs['serviceCost'],
              );
            }
            if (!_isSelected) {
              widget.removeServiceFunction(
                name: widget.servicesDocs['serviceName'],
                type: widget.servicesDocs['serviceType'],
              );
            }
          });
        },
      ),
    );
  }
}

class PartsList extends StatefulWidget {
  const PartsList({Key? key}) : super(key: key);

  @override
  State<PartsList> createState() => _PartsListState();
}

class _PartsListState extends State<PartsList> {
  List<Parts> _listOfParts = [];

  void _addParts({
    required String name,
    required String type,
    required int cost,
    required int duration,
  }) {
    _listOfParts.add(
      Parts(
        partName: name,
        partType: type,
        partCost: cost,
        partInstallDuration: duration,
      ),
    );
    for (var element in _listOfParts) {
      print(element.partName);
    }
  }

  void _removePart({
    required String name,
    required String type,
  }) {
    _listOfParts.removeWhere(
        (element) => (element.partName == name && element.partType == type));
    for (var element in _listOfParts) {
      print(element.partName);
    }
  }

  int get partsCost {
    int cost = 0;
    for (var element in _listOfParts) {
      cost += element.partCost;
    }
    return cost;
  }

  int get partsDuration {
    int duration = 0;
    for (var element in _listOfParts) {
      duration += element.partInstallDuration;
    }
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('serviceProviders')
              .doc(futureSnapshot.data?.uid)
              .collection('inventoryList')
              .orderBy(
                'dateAdded',
                descending: true,
              )
              .snapshots(),
          builder: (ctx, partsSnapshot) {
            if (partsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (partsSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Parts added yet'),
              );
            }
            final inventoryDocs = partsSnapshot.data!.docs;
            return ListView.builder(
              itemCount: inventoryDocs.length,
              itemBuilder: (ctx, index) {
                return EstimatePartsItem(
                  inventoryDocs: inventoryDocs[index],
                  addPartFunc: _addParts,
                  removePartFunction: _removePart,
                );
              },
            );
          },
        );
      },
    );
  }
}

class EstimatePartsItem extends StatefulWidget {
  const EstimatePartsItem({
    Key? key,
    required this.inventoryDocs,
    required this.addPartFunc,
    required this.removePartFunction,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> inventoryDocs;
  final void Function({
    required String name,
    required String type,
    required int cost,
    required int duration,
  }) addPartFunc;
  final void Function({
    required String name,
    required String type,
  }) removePartFunction;

  @override
  State<EstimatePartsItem> createState() => _EstimatePartsItemState();
}

class _EstimatePartsItemState extends State<EstimatePartsItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: ValueKey(widget.inventoryDocs),
        leading: SizedBox(
          height: double.infinity,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.inventoryDocs['partQuantity'].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          widget.inventoryDocs['partName'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.inventoryDocs['partType'],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part Cost: ${widget.inventoryDocs['partCost']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Installation Duration: ${widget.inventoryDocs['partDuration']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (newValue) {
            setState(() {
              isSelected = newValue!;
              if (isSelected) {
                widget.addPartFunc(
                  name: widget.inventoryDocs['partName'],
                  type: widget.inventoryDocs['partType'],
                  cost: widget.inventoryDocs['partCost'],
                  duration: widget.inventoryDocs['partDuration'],
                );
              }
              if (!isSelected) {
                widget.removePartFunction(
                  name: widget.inventoryDocs['partName'],
                  type: widget.inventoryDocs['partType'],
                );
              }
            });
          },
        ),
      ),
    );
  }
}
