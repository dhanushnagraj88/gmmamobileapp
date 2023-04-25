class VehiclesList {
  final List<String> _typeOfVehicleList = [
    'Two-Wheeler',
    'Four- Wheeler',
    'Auto Rickshaw',
    'Truck',
    'Bus',
    'Other',
  ];

  final List<String> _vehicleMakeList = [];

  final List<Map<String, dynamic>> _twoWheelerVehicles = [
    {
      'make': 'Bajaj Auto',
      'model': [
        'Pulsar N160',
        'Pulsar F250',
        'Pulsar RS200',
        'Pulsar NS200',
        'Pulsar NS160',
        'Pulsar 150',
        'Pulsar NS125',
        'Pulsar 125',
        'Pulsar 220 F',
        'Dominar 250',
        'Dominar 400',
        'Avenger 160 Street',
        'Avenger 220 Cruise',
        'Platina 100',
        'Platina 110',
        'CT 125X',
        'CT 110X',
      ],
    },
    {
      'make': 'Royal Enfield',
      'model': [
        'Hunter 350',
        'Classic 350',
        'Bullet 350',
        'Continental GT 650',
        'Meteor 350',
        'Himalayan',
        'Super Meteor 650',
        'Interceptor 650',
        'Scram 411',
      ],
    },
    {
      'make': 'Hero Motocorp',
      'model': [
        'Splendor Plus',
        'HF Deluxe',
        'Splendor Plus Xtec',
        'Super Splendor',
        'Xtreme 160R',
        'Glamour',
        'Xpulse 200 4V',
        'Passion Pro',
        'Pleasure+',
        'Passion Xtec',
        'Glamour Xtec',
        'Xtreme 200S',
        'Xpulse 200T 4V',
        'Pleasure+ Xtec',
        'Maestro Edge 1525',
        'Destini 125 Xtec',
        'Maestro Edge 110',
        'Xoom',
        'Super Splendor Xtec',
      ],
    },
    {
      'make': 'Honda Motorcycle',
      'model': [
        'SP 125',
        'Shine',
        'Unicorn',
        'H\'ness CB350',
        'Hornet 2.0',
        'Shine 100',
        'XBlade',
        'Livo',
        'CD 110 Dream',
        'CBR650R',
        'CB350RS',
        'CB300R',
        'CB300F',
        'Gold Wing',
        'CB650R',
        'CRF1100L Africa Twin',
        'CBR1000RR-R',
        'CB500X',
        'CB200X',
        'CB Hornet 160R',
        'Grazia',
        'Activa 125',
        'Dio',
        'Activa',
      ],
    }
  ];

  List<String> get typeOfVehicles {
    return _typeOfVehicleList;
  }

  List<String> get vehicleMakeList {
    for (var vehicle in _twoWheelerVehicles) {
      String make = vehicle['make'];
      _vehicleMakeList.add(make);
    }

    return _vehicleMakeList;
  }

  List<String> getModelsForMake(String make) {
    for (var vehicle in _twoWheelerVehicles) {
      if (vehicle['make'] == make) {
        return List<String>.from(vehicle['model']);
      }
    }
    return [];
  }
}
