import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends BaseModel with JsonHelperMixin {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  @JsonKey(name: 'avatar_original')
  final String? avatarUrl;
  @JsonKey(name: 'user_type')
  final String? userType;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(defaultValue: false)
  final bool isVerified;
  final String? token;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.userType,
    this.createdAt,
    this.emailVerifiedAt,
    this.isVerified = false,
    this.token,
  });

  /// Creates a User instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? userType,
    DateTime? createdAt,
    DateTime? emailVerifiedAt,
    bool? isVerified,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
    );
  }

  /// Returns true if the user has a verified email
  bool get hasVerifiedEmail => emailVerifiedAt != null;

  /// Returns true if the user has an avatar
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// Returns true if the user is a customer (not admin or seller)
  bool get isCustomer => userType == 'customer';

  /// Returns true if the user is an admin
  bool get isAdmin => userType == 'admin';

  /// Returns true if the user is a seller
  bool get isSeller => userType == 'seller';

  /// Returns true if the user has provided a phone number
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  /// Returns true if the user has provided an email
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Returns the user's initials based on their name
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  /// Returns a display name (email if name is not available)
  String get displayName => name.isNotEmpty ? name : email ?? 'Unknown User';
}

/// Extension to add additional functionality to User
extension UserX on User {
  /// Returns true if the user has all required profile information
  bool get hasCompleteProfile {
    return name.isNotEmpty && 
           hasEmail && 
           hasPhone && 
           isVerified;
  }

  /// Returns a list of missing profile items
  List<String> get missingProfileItems {
    final missing = <String>[];
    
    if (name.isEmpty) missing.add('Name');
    if (!hasEmail) missing.add('Email');
    if (!hasPhone) missing.add('Phone');
    if (!isVerified) missing.add('Verification');
    
    return missing;
  }
}
