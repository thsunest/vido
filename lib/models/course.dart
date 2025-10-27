class Course {
  final int id;
  final int anchorId;
  final int type;
  final String name;
  final int price;
  final String nameEn;

  Course({
    required this.id,
    required this.anchorId,
    required this.type,
    required this.name,
    required this.price,
    required this.nameEn,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    final dynamic priceValue = json['price'];
    final dynamic aIdValue = json['anchor_id'];
    int parsedId;
    int parsedPrice;
    int parsedAnchorId;

    if (priceValue is String) {
      parsedPrice = int.tryParse(priceValue) ?? 0;
    } else if (priceValue is int) {
      parsedPrice = priceValue;
    } else {
      parsedPrice = 0;
    }

    if (idValue is String) {
      parsedId = int.tryParse(idValue) ?? 0;
    } else if (idValue is int) {
      parsedId = idValue;
    } else {
      parsedId = 0;
    }
    if (aIdValue is String) {
      parsedAnchorId = int.tryParse(aIdValue) ?? 0;
    } else if (aIdValue is int) {
      parsedAnchorId = aIdValue;
    } else {
      parsedAnchorId = 0;
    }
    return Course(
      id: parsedId,
      anchorId: parsedAnchorId,
      type: json['type'] as int,
      name: json['name'] as String,
      price: parsedPrice,
      nameEn: json['name_en'] as String,
    );
  }
}
