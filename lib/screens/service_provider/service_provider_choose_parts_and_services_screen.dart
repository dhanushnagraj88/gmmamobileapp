import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/services_and_parts.dart';

class ServiceProviderChoosePartsAndServicesScreen extends StatefulWidget {
  const ServiceProviderChoosePartsAndServicesScreen({Key? key})
      : super(key: key);

  static const routeName = '/service-provider-choose-parts-and-services-screen';

  @override
  State<ServiceProviderChoosePartsAndServicesScreen> createState() =>
      _ServiceProviderChoosePartsAndServicesScreenState();
}

class _ServiceProviderChoosePartsAndServicesScreenState
    extends State<ServiceProviderChoosePartsAndServicesScreen> {
  User? userData;
  DocumentSnapshot<Map<String, dynamic>>? collectionsData;
  final servicesListKey = GlobalKey<_ServicesListState>();
  final partsListKey = GlobalKey<_PartsListState>();
  Map<String, dynamic>? _args;

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

  void _createJobCard(
    List<Services> services,
    List<Parts> parts,
    BuildContext ctx,
  ) async {
    // final docId = DateTime.now();
    TextEditingController textFieldController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Job Card'),
        content: const Text('Are you sure want to add this job card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    List<Map<String, dynamic>> listOfPartsAndServices = [];
    for (var element in services) {
      Map<String, dynamic> data = {
        'name': element.serviceName,
        'type': element.serviceType,
        'cost': element.serviceCost,
        'duration': element.serviceDuration,
      };
      listOfPartsAndServices.add(data);
    }
    for (var element in parts) {
      Map<String, dynamic> data = {
        'name': element.partName,
        'type': element.partType,
        'cost': element.partCost,
        'duration': element.partInstallDuration,
      };
      listOfPartsAndServices.add(data);
    }
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter a title for the Job Card'),
        content: TextField(
          controller: textFieldController,
          decoration: InputDecoration(hintText: 'Job card Title'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('serviceProviders')
                  .doc(userData?.uid)
                  .collection('pendingJobsList')
                  .add(
                {
                  'jobTitle': textFieldController.text,
                  'jobDetails': listOfPartsAndServices,
                  'vehicleNumber': _args!['vehicleNumber'],
                  'ownerName': _args!['ownerName'],
                  'userID': _args!['userID'],
                  'vehicleType': _args!['vehicleType'],
                  'vehicleMake': _args!['vehicleMake'],
                  'vehicleModel': _args!['vehicleModel'],
                  'jobStatus': 'Pending',
                  'totalCost': totalCost,
                  'totalDuration': totalDuration,
                  'dateAdded': DateTime.now(),
                  'ownerID': userData?.uid,
                  'upiID': collectionsData?.data()!['upiId']
                },
              );
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            child: Text('Confirm Job Card'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUserData();
    super.initState();
  }

  int totalCost = 0;
  int totalDuration = 0;
  List<Services> totalServices = [];
  List<Parts> totalParts = [];
  // ServicesList servicesList = const ServicesList();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _args = args;
    return Scaffold(
      appBar: AppBar(
        title: Text('Estimate for ${args['vehicleNumber']}'),
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
              if (totalCost != 0 && totalDuration != 0)
                ElevatedButton(
                  onPressed: () {
                    final servicesListState =
                        servicesListKey.currentState as _ServicesListState;
                    final services = servicesListState.listOfServices;
                    final partsListState =
                        partsListKey.currentState as _PartsListState;
                    final parts = partsListState.listOfParts;
                    setState(() {
                      totalServices.addAll(services);
                      totalParts.addAll(parts);
                    });
                    _createJobCard(
                      totalServices,
                      totalParts,
                      context,
                    );
                  },
                  child: const Text('Create Job Card'),
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
  }

  void _removeService({
    required String name,
    required String type,
  }) {
    _listOfServices.removeWhere((element) =>
        (element.serviceName == name && element.serviceType == type));
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

  List<Services> get listOfServices {
    return _listOfServices;
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
  }

  void _removePart({
    required String name,
    required String type,
  }) {
    _listOfParts.removeWhere(
        (element) => (element.partName == name && element.partType == type));
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

  List<Parts> get listOfParts {
    return _listOfParts;
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
