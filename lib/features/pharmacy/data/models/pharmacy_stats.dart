class PharmacyStats {
  final int newRequests;
  final int pendingRequests;
  final int completedToday;
  final int totalRequests;
  final double responseRate;

  PharmacyStats({
    required this.newRequests,
    required this.pendingRequests,
    required this.completedToday,
    required this.totalRequests,
    required this.responseRate,
  });

  factory PharmacyStats.empty() {
    return PharmacyStats(
      newRequests: 0,
      pendingRequests: 0,
      completedToday: 0,
      totalRequests: 0,
      responseRate: 0.0,
    );
  }
}
