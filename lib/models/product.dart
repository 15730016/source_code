import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product extends BaseModel with JsonHelperMixin {
  final int id;
  final String name;
  @JsonKey(name: 'thumbnail_image')
  final String? thumbnailImage;
  @JsonKey(name: 'main_price')
  final String mainPrice;
  @JsonKey(name: 'stroked_price')
  final String? strokedPrice;
  @JsonKey(name: 'has_discount')
  final bool hasDiscount;
  @JsonKey(name: 'discount')
  final String? discount;
  final int? rating;
  @JsonKey(name: 'sales')
  final int totalSales;
  @JsonKey(name: 'links')
  final ProductLinks links;
  final List<String> photos;
  @JsonKey(name: 'category_ids')
  final List<int> categoryIds;
  final List<String> tags;
  @JsonKey(name: 'brand_id')
  final int? brandId;
  final String description;
  @JsonKey(name: 'is_wholesale')
  final bool isWholesale;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @JsonKey(name: 'is_refundable')
  final bool isRefundable;
  @JsonKey(name: 'current_stock')
  final int currentStock;
  @JsonKey(name: 'min_qty')
  final int minQuantity;
  @JsonKey(name: 'max_qty')
  final int? maxQuantity;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.thumbnailImage,
    required this.mainPrice,
    this.strokedPrice,
    this.hasDiscount = false,
    this.discount,
    this.rating,
    required this.totalSales,
    required this.links,
    required this.photos,
    required this.categoryIds,
    required this.tags,
    this.brandId,
    required this.description,
    this.isWholesale = false,
    this.isFeatured = false,
    this.isRefundable = true,
    required this.currentStock,
    required this.minQuantity,
    this.maxQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a Product instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  Product copyWith({
    int? id,
    String? name,
    String? thumbnailImage,
    String? mainPrice,
    String? strokedPrice,
    bool? hasDiscount,
    String? discount,
    int? rating,
    int? totalSales,
    ProductLinks? links,
    List<String>? photos,
    List<int>? categoryIds,
    List<String>? tags,
    int? brandId,
    String? description,
    bool? isWholesale,
    bool? isFeatured,
    bool? isRefundable,
    int? currentStock,
    int? minQuantity,
    int? maxQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
      mainPrice: mainPrice ?? this.mainPrice,
      strokedPrice: strokedPrice ?? this.strokedPrice,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      totalSales: totalSales ?? this.totalSales,
      links: links ?? this.links,
      photos: photos ?? this.photos,
      categoryIds: categoryIds ?? this.categoryIds,
      tags: tags ?? this.tags,
      brandId: brandId ?? this.brandId,
      description: description ?? this.description,
      isWholesale: isWholesale ?? this.isWholesale,
      isFeatured: isFeatured ?? this.isFeatured,
      isRefundable: isRefundable ?? this.isRefundable,
      currentStock: currentStock ?? this.currentStock,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns true if the product is in stock
  bool get isInStock => currentStock > 0;

  /// Returns true if the product has a valid rating
  bool get hasRating => rating != null && rating! > 0;

  /// Returns the discount percentage if available
  double? get discountPercentage {
    if (!hasDiscount || discount == null) return null;
    return double.tryParse(discount!.replaceAll('%', ''));
  }

  /// Returns the main price as a double
  double get mainPriceAsDouble {
    return double.tryParse(mainPrice.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }

  /// Returns true if the product has multiple photos
  bool get hasMultiplePhotos => photos.length > 1;

  /// Returns true if quantity restrictions apply
  bool get hasQuantityRestrictions => maxQuantity != null && maxQuantity! > 0;

  /// Returns the maximum allowed quantity (considering stock)
  int get maxAllowedQuantity {
    if (maxQuantity == null) return currentStock;
    return maxQuantity! < currentStock ? maxQuantity! : currentStock;
  }
}

@JsonSerializable()
class ProductLinks {
  final String details;
  final String reviews;
  final String related;
  @JsonKey(name: 'top_from_seller')
  final String topFromSeller;

  ProductLinks({
    required this.details,
    required this.reviews,
    required this.related,
    required this.topFromSeller,
  });

  factory ProductLinks.fromJson(Map<String, dynamic> json) => 
      _$ProductLinksFromJson(json);

  Map<String, dynamic> toJson() => _$ProductLinksToJson(this);
}

/// Extension to add additional functionality to Product
extension ProductX on Product {
  /// Returns true if the product is on sale
  bool get isOnSale => hasDiscount && strokedPrice != null;

  /// Returns true if the product is new (less than 7 days old)
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays < 7;
  }

  /// Returns a list of product highlights
  List<String> get highlights {
    final highlights = <String>[];
    
    if (isNew) highlights.add('New Arrival');
    if (isOnSale) highlights.add('On Sale');
    if (isFeatured) highlights.add('Featured');
    if (isWholesale) highlights.add('Wholesale');
    if (isRefundable) highlights.add('Refundable');
    
    return highlights;
  }
}
