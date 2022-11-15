import 'dart:convert';

class User {
  final int? id;
  final String? userName;
  final String? passwordhash;
  final String? email;
  final String? authKey;
  final int? status;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? frontIDPhoto;
  final String? group;
  final String? backIDPhoto;
  final String? name;
  final String? phone;
  final String? identityNumber;
  final String? address;
  final String? active;
  final DateTime? birthDay;

  User({
    DateTime? birthDay,
    this.id,
    this.userName,
    this.passwordhash,
    this.email,
    this.authKey,
    this.status,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.frontIDPhoto,
    this.group,
    this.backIDPhoto,
    this.name,
    this.phone,
    this.identityNumber,
    this.address,
    this.active,
  }) : birthDay = birthDay ?? DateTime.now();

  User copyWith({
    int? id,
    String? userName,
    String? passwordhash,
    String? email,
    String? authKey,
    int? status,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? frontIDPhoto,
    String? group,
    String? backIDPhoto,
    String? name,
    String? phone,
    String? identityNumber,
    String? address,
    String? active,
    DateTime? birthDay,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      passwordhash: passwordhash ?? this.passwordhash,
      email: email ?? this.email,
      authKey: authKey ?? this.authKey,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      frontIDPhoto: frontIDPhoto ?? this.frontIDPhoto,
      group: group ?? this.group,
      backIDPhoto: backIDPhoto ?? this.backIDPhoto,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      identityNumber: identityNumber ?? this.identityNumber,
      address: address ?? this.address,
      active: active ?? this.active,
      birthDay: birthDay ?? this.birthDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': userName,
      'password_hash': passwordhash,
      'email': email,
      'auth_key': authKey,
      'status': status,
      'anh_nguoi_dung': profileImageUrl,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
      'anh_truoc_cccd': frontIDPhoto,
      'nhom': group,
      'anh_sau_cccd': backIDPhoto,
      'hoten': name,
      'dien_thoai': phone,
      'cmnd': identityNumber,
      'dia_chi': address,
      'active': active,
      'ngay_sinh': birthDay?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      userName: map['username'] != null ? map['username'] as String : null,
      passwordhash: map['password_hash'] != null ? map['password_hash'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      authKey: map['auth_key'] != null ? map['auth_key'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      profileImageUrl: map['anh_nguoi_dung'] != null ? map['anh_nguoi_dung'] as String : null,
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? ''),
      frontIDPhoto: map['anh_truoc_cccd'] != null ? map['anh_truoc_cccd'] as String : null,
      group: map['nhom'] != null ? map['nhom'] as String : null,
      backIDPhoto: map['anh_sau_cccd'] != null ? map['anh_sau_cccd'] as String : null,
      name: map['hoten'] != null ? map['hoten'] as String : null,
      phone: map['dien_thoai'] != null ? map['dien_thoai'] as String : null,
      identityNumber: map['cmnd'] != null ? map['cmnd'] as String : null,
      address: map['dia_chi'] != null ? map['dia_chi'] as String : null,
      active: map['kich_hoat'] != null ? map['kich_hoat'] as String : null,
      birthDay: DateTime.tryParse(map['ngay_sinh'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfo(id: $id, userName: $userName, passwordhash: $passwordhash, email: $email, authKey: $authKey, status: $status, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt, frontIDPhoto: $frontIDPhoto, group: $group, backIDPhoto: $backIDPhoto, name: $name, phone: $phone, identityNumber: $identityNumber, address: $address, active: $active, birthDay: $birthDay)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.passwordhash == passwordhash &&
        other.email == email &&
        other.authKey == authKey &&
        other.status == status &&
        other.profileImageUrl == profileImageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.frontIDPhoto == frontIDPhoto &&
        other.group == group &&
        other.backIDPhoto == backIDPhoto &&
        other.name == name &&
        other.phone == phone &&
        other.identityNumber == identityNumber &&
        other.address == address &&
        other.active == active &&
        other.birthDay == birthDay;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        passwordhash.hashCode ^
        email.hashCode ^
        authKey.hashCode ^
        status.hashCode ^
        profileImageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        frontIDPhoto.hashCode ^
        group.hashCode ^
        backIDPhoto.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        identityNumber.hashCode ^
        address.hashCode ^
        active.hashCode ^
        birthDay.hashCode;
  }
}
