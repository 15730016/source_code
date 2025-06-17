import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';

part 'brand.g.dart';

@JsonSerializable(explicitToJson: true)
class Brand extends BaseModel with JsonHelperMixin {
  final int id;
  final String name;
  final String? logo;
  @JsonKey(name: 'meta_title')
  final String? metaTitle;
  @JsonKey(name: 'meta_description')
  final String? metaDescription;
  final String slug;
  @JsonKey(name: 'total_products')
  final int totalProducts;
  @JsonKey(name: 'featured')
  final bool isFeatured;
  @JsonKey(name: 'top')
  final bool isTop;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'links')
  final BrandLinks links;

  Brand({
    required this.id,
    required this.name,
    this.logo,
    this.metaTitle,
    this.metaDescription,
    required this.slug,
    required this.totalProducts,
    this.isFeatured = false,
    this.isTop = false,
    required this.createdAt,
    required this.updatedAt,
    required this.links,
  });

  /// Creates a Brand instance from JSON
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BrandToJson(this);

  @override
  Brand copyWith({
    int? id,
    String? name,
    String? logo,
    String? metaTitle,
    String? metaDescription,
    String? slug,
    int? totalProducts,
    bool? isFeatured,
    bool? isTop,
    String? createdAt,
    String? updatedAt,
    BrandLinks? links,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      metaTitle: metaTitle ?? this.metaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      slug: slug ?? this.slug,
      totalProducts: totalProducts ?? this.totalProducts,
      isFeatured: isFeatured ?? this.isFeatured,
      isTop: isTop ?? this.isTop,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      links: links ?? this.links,
    );
  }

  /// Returns true if the brand has a logo
  bool get hasLogo => logo != null && logo!.isNotEmpty;

  /// Returns true if the brand has products
  bool get hasProducts => totalProducts > 0;

  /// Returns true if the brand has meta information
  bool get hasMetaInfo => 
      (metaTitle != null && metaTitle!.isNotEmpty) || 
      (metaDescription != null && metaDescription!.isNotEmpty);

  /// Returns the creation date as DateTime
  DateTime get creationDate => DateTime.parse(createdAt);

  /// Returns the last update date as DateTime
  DateTime get lastUpdateDate => DateTime.parse(updatedAt);

  /// Returns the brand's display name (meta title if available, otherwise name)
  String get displayName => metaTitle ?? name;

  /// Returns the brand's description (meta description if available)
  String get description => metaDescription ?? 'No description available';

  /// Returns true if the brand is newly added (within last 30 days)
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(creationDate);
    return difference.inDays <= 30;
  }

  /// Returns true if the brand was recently updated (within last 7 days)
  bool get wasRecentlyUpdated {
    final now = DateTime.now();
    final difference = now.difference(lastUpdateDate);
    return difference.inDays <= 7;
  }
}

@JsonSerializable()
class BrandLinks {
  final String products;
  @JsonKey(name: 'featured_products')
  final String featuredProducts;

  BrandLinks({
    required this.products,
    required this.featuredProducts,
  });

  factory BrandLinks.fromJson(Map<String, dynamic> json) => 
      _$BrandLinksFromJson(json);

  Map<String, dynamic> toJson() => _$BrandLinksToJson(this);
}

/// Extension to add additional functionality to Brand
extension BrandX on Brand {
  /// Returns a list of brand features/highlights
  List<String> get features {
    final features = <String>[];
    
    if (isNew) features.add('New Brand');
    if (isFeatured) features.add('Featured');
    if (isTop) features.add('Top Brand');
    if (hasProducts) features.add('$totalProducts Products');
    if (wasRecentlyUpdated) features.add('Recently Updated');
    
    return features;
  }

  /// Returns SEO-friendly title
  String get seoTitle {
    if (metaTitle != null && metaTitle!.isNotEmpty) {
      return metaTitle!;
    }
    return '$name - Products and Collections';
  }

  /// Returns SEO-friendly description
  String get seoDescription {
    if (metaDescription != null && metaDescription!.isNotEmpty) {
      return metaDescription!;
    }
    return 'Discover $name products and collections. Browse through our selection of ${totalProducts} items.';
  }

  /// Returns brand status based on various factors
  BrandStatus get status {
    if (!hasProducts) {
      return BrandStatus.empty;
    } else if (isTop && isFeatured) {
      return BrandStatus.premium;
    } else if (isTop || isFeatured) {
      return BrandStatus.featured;
    } else {
      return BrandStatus.active;
    }
  }

  /// Returns a color associated with the brand's status
  String get statusColor {
    switch (status) {
      case BrandStatus.premium:
        return '#FFD700'; // Gold
      case BrandStatus.featured:
        return '#4CAF50'; // Green
      case BrandStatus.active:
        return '#2196F3'; // Blue
      case BrandStatus.empty:
        return '#9E9E9E'; // Grey
    }
  }
}

/// Enum representing different brand statuses
enum BrandStatus {
  premium,
  featured,
  active,
  empty,
}
