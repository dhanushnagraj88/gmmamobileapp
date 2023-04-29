class Services {
  final String serviceName;
  final String serviceType;
  final int serviceCost;
  final int serviceDuration;

  const Services({
    required this.serviceName,
    required this.serviceType,
    required this.serviceCost,
    required this.serviceDuration,
  });
}

class Parts {
  final String partName;
  final String partType;
  final int partCost;
  final int partInstallDuration;

  const Parts({
    required this.partName,
    required this.partType,
    required this.partCost,
    required this.partInstallDuration,
  });
}
