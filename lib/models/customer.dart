import 'dart:convert';

class Customer {
  int? id;
  String? name;
  String? phone;
  String? active;
  String? note;
  Customer({
    this.id,
    this.name,
    this.phone,
    this.active,
    this.note,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? active,
    String? note,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hoten': name,
      'dien_thoai': phone,
      'kich_hoat': active,
      'ghi_chu': note,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['hoten'] != null ? map['hoten'] as String : null,
      phone: map['dien_thoai'] != null ? map['dien_thoai'] as String : null,
      active: map['kich_hoat'] != null ? map['kich_hoat'] as String : null,
      note: map['ghi_chu'] != null ? map['ghi_chu'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, phone: $phone, active: $active, note: $note)';
  }

  @override
  bool operator ==(covariant Customer other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.phone == phone && other.active == active && other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ phone.hashCode ^ active.hashCode ^ note.hashCode;
  }
}
