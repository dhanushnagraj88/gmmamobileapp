import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class CustomerPaymentsScreen extends StatefulWidget {
  const CustomerPaymentsScreen({Key? key}) : super(key: key);

  static const routeName = '/customer-payments-screen';

  @override
  State<CustomerPaymentsScreen> createState() => _CustomerPaymentsScreenState();
}

class _CustomerPaymentsScreenState extends State<CustomerPaymentsScreen> {
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  QueryDocumentSnapshot<Map<String, dynamic>>? _arguments;
  User? userData = FirebaseAuth.instance.currentUser;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: 'nkrishnappa@ybl',
      receiverName: _arguments!.data()['ownerName'],
      transactionRefId: _arguments!.data()['dateAdded'].toString(),
      transactionNote: 'Not actual. Just an example.',
      amount: double.parse(_arguments!.data()['totalCost'].toString()),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app did not return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  String _checkTxnStatus(String status) {
    String txStatus;
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        txStatus = 'Transaction Successful';
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        txStatus = 'Transaction Submitted';
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        txStatus = 'Transaction Failed';
        print('Transaction Failed');
        break;
      default:
        txStatus = 'Received an Unknown transaction status';
        print('Received an Unknown transaction status');
    }
    return txStatus;
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  void transSuccessful() async {
    await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(_arguments!.data()['ownerID'])
        .collection('transactionsList')
        .add(_arguments!.data());
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(_arguments!.data()['ownerID'])
        .collection('pendingPaymentsList')
        .where('dateAdded', isEqualTo: _arguments!.data()['dateAdded'])
        .get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for (DocumentSnapshot document in documents) {
      await document.reference.delete();
    }
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(userData?.uid)
        .collection('pendingPayments')
        .doc(_arguments?.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as QueryDocumentSnapshot<Map<String, dynamic>>;
    if (args != null) {
      setState(() {
        _arguments = args;
      });
    }
    if (_arguments == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        style: header,
                      ), // Print's text message on screen
                    );
                  }

                  // If we have data then definitely we will have UpiResponse.
                  // It cannot be null
                  UpiResponse _upiResponse = snapshot.data!;

                  // Data in UpiResponse can be null. Check before printing
                  String txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  String transStatus = _checkTxnStatus(status);

                  if (transStatus == 'Transaction Successful') {}

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(''),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
