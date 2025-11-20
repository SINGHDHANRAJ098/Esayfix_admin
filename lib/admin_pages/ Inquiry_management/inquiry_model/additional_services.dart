

class AdditionalService {
  final String name;
  final int qty;
  final double price;

  AdditionalService({
    required this.name,
    required this.qty,
    required this.price,
  });

  double get total => qty * price;

  AdditionalService copyWith({
    String? name,
    int? qty,
    double? price,
  }) {
    return AdditionalService(
      name: name ?? this.name,
      qty: qty ?? this.qty,
      price: price ?? this.price,
    );
  }
}
