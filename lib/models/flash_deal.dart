import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';
import 'package:active_ecommerce_cms_demo_app/models/product.dart';

part 'flash_deal.g.dart';

@JsonSerializable(explicitToJson: true)
class FlashDeal extends BaseModel with JsonHelperMixin {
  final int id;
  final String title;
  @JsonKey(name: 'banner')
  final String bannerImage;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  final String status;
  @JsonKey(name: 'featured')
  final bool isFeatured;
  @JsonKey(name: 'background_color')
  final String backgroundColor;
  @JsonKey(name: 'text_color')
  final String textColor;
  @JsonKey(name: 'banner_position')
  final String bannerPosition;
  @JsonKey(name: 'slug')
  final String slug;
  @JsonKey(defaultValue: [])
  final List<FlashDealProduct> products;

  FlashDeal({
    required this.id,
    required this.title,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.isFeatured = false,
    required this.backgroundColor,
    required this.textColor,
    required this.bannerPosition,
    required this.slug,
    this.products = const [],
  });

  /// Creates a FlashDeal instance from JSON
  factory FlashDeal.fromJson(Map<String, dynamic> json) => 
      _$FlashDealFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FlashDealToJson(this);

  @override
  FlashDeal copyWith({
    int? id,
    String? title,
    String? bannerImage,
    String? startDate,
    String? endDate,
    String? status,
    bool? isFeatured,
    String? backgroundColor,
    String? textColor,
    String? bannerPosition,
    String? slug,
    List<FlashDealProduct>? products,
  }) {
    return FlashDeal(
      id: id ?? this.id,
      title: title ?? this.title,
      bannerImage: bannerImage ?? this.bannerImage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      bannerPosition: bannerPosition ?? this.bannerPosition,
      slug: slug ?? this.slug,
      products: products ?? this.products,
    );
  }

  /// Returns the start date as DateTime
  DateTime get startDateTime => DateTime.parse(startDate);

  /// Returns the end date as DateTime
  DateTime get endDateTime => DateTime.parse(endDate);

  /// Returns true if the flash deal is currently active
  bool get isActive {
    final now = DateTime.now();
    return status == 'active' &&
           now.isAfter(startDateTime) &&
           now.isBefore(endDateTime);
  }

  /// Returns true if the flash deal has started
  bool get hasStarted => DateTime.now().isAfter(startDateTime);

  /// Returns true if the flash deal has ended
  bool get hasEnded => DateTime.now().isAfter(endDateTime);

  /// Returns true if the flash deal has products
  bool get hasProducts => products.isNotEmpty;

  /// Returns the time remaining until the deal ends
  Duration get timeRemaining {
    if (hasEnded) return Duration.zero;
    return endDateTime.difference(DateTime.now());
  }

  /// Returns the time until the deal starts
  Duration get timeUntilStart {
    if (hasStarted) return Duration.zero;
    return startDateTime.difference(DateTime.now());
  }

  /// Returns the total duration of the flash deal
  Duration get totalDuration {
    return endDateTime.difference(startDateTime);
  }

  /// Returns the progress percentage of the flash deal
  double get progressPercentage {
    if (!hasStarted) return 0.0;
    if (hasEnded) return 1.0;
    
    final totalDurationInSeconds = totalDuration.inSeconds;
    final elapsedSeconds = DateTime.now().difference(startDateTime).inSeconds;
    
    return elapsedSeconds / totalDurationInSeconds;
  }

  /// Returns products sorted by discount percentage
  List<FlashDealProduct> get productsSortedByDiscount {
    return List.from(products)
      ..sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
  }
}

@JsonSerializable(explicitToJson: true)
class FlashDealProduct extends BaseModel with JsonHelperMixin {
  final Product product;
  @JsonKey(name: 'discount')
  final int discountPercentage;
  @JsonKey(name: 'discount_type')
  final String discountType;
  @JsonKey(name: 'base_price')
  final String basePrice;
  @JsonKey(name: 'discounted_price')
  final String discountedPrice;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'sold')
  final int soldQuantity;

  FlashDealProduct({
    required this.product,
    required this.discountPercentage,
    required this.discountType,
    required this.basePrice,
    required this.discountedPrice,
    required this.quantity,
    required this.soldQuantity,
  });

  factory FlashDealProduct.fromJson(Map<String, dynamic> json) => 
      _$FlashDealProductFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FlashDealProductToJson(this);

  @override
  FlashDealProduct copyWith({
    Product? product,
    int? discountPercentage,
    String? discountType,
    String? basePrice,
    String? discountedPrice,
    int? quantity,
    int? soldQuantity,
  }) {
    return FlashDealProduct(
      product: product ?? this.product,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountType: discountType ?? this.discountType,
      basePrice: basePrice ?? this.basePrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      quantity: quantity ?? this.quantity,
      soldQuantity: soldQuantity ?? this.soldQuantity,
    );
  }

  /// Returns the base price as double
  double get basePriceValue => double.parse(basePrice);

  /// Returns the discounted price as double
  double get discountedPriceValue => double.parse(discountedPrice);

  /// Returns the amount saved
  double get savingsAmount => basePriceValue - discountedPriceValue;

  /// Returns true if the product is in stock
  bool get isInStock => remainingQuantity > 0;

  /// Returns the remaining quantity
  int get remainingQuantity => quantity - soldQuantity;

  /// Returns the percentage of stock sold
  double get soldPercentage => (soldQuantity / quantity) * 100;

  /// Returns true if stock is running low (less than 20% remaining)
  bool get isLowStock => remainingQuantity <= (quantity * 0.2);

  /// Returns formatted savings amount
  String get formattedSavings => savingsAmount.toStringAsFixed(2);
}

/// Extension to add additional functionality to FlashDeal
extension FlashDealX on FlashDeal {
  /// Returns formatted time remaining
  String get formattedTimeRemaining {
    final duration = timeRemaining;
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Returns total savings across all products
  double get totalSavings {
    return products.fold(0.0, (sum, product) => sum + product.savingsAmount);
  }

  /// Returns average discount percentage
  double get averageDiscount {
    if (products.isEmpty) return 0.0;
    final total = products.fold(0, (sum, product) => sum + product.discountPercentage);
    return total / products.length;
  }

  /// Returns total quantity sold
  int get totalQuantitySold {
    return products.fold(0, (sum, product) => sum + product.soldQuantity);
  }

  /// Returns total available quantity
  int get totalQuantityAvailable {
    return products.fold(0, (sum, product) => sum + product.remainingQuantity);
  }
}
