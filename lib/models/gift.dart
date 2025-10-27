class Gift {
  int? id;
  int? anchorId;
  final String key;
  final String value;
  int? type;
  String? svga;
  String? valueEn;
  int? price;
  int? duration;
  String? nameEn;

  Gift({
    this.id,
    this.anchorId,
    required this.key,
    required this.value,
    this.valueEn,
    this.price,
    this.duration,
    this.nameEn,
    this.type,
    this.svga,
  });

  // 从 JSON Map 创建 Gift 对象的工厂构造函数
  factory Gift.fromJson(Map<String, dynamic> json) {
    // 优先使用 'name' 字段，如果不存在则使用 'value'
    final nameValue = json['name'] as String? ?? json['value'] as String? ?? '';
    return Gift(
      id: json['id'] as int?,
      anchorId: json['anchor_id'] as int?,
      key: json['key'] as String,
      value: nameValue,
      price: json['price'] as int?,
      duration: json['duration'] as int?,
      valueEn: json['value_en'] as String?,
      nameEn: json['name_en'] as String?,
      type: json['type'] as int?,
      svga: json['svga'] as String?,
    );
  }
  // 将 Gift 对象转换为 JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anchor_id': anchorId,
      'key': key,
      'value': value,
      'value_en': valueEn,
      'price': price,
      'duration': duration,
      'name_en': nameEn,
    };
  }
}
