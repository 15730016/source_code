import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';
import 'package:active_ecommerce_cms_demo_app/models/product.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart extends BaseModel with JsonHelperMixin {
  final List<CartItem> items;
  @JsonKey(name: 'sub_total')
  final String subTotal;
  @JsonKey(name: 'tax')
  final String tax;
  @JsonKey(name: 'shipping_cost')
  final String shippingCost;
  @JsonKey(name: 'discount')
  final String discount;
  @JsonKey(name: 'grand_total')
  final String grandTotal;
  @JsonKey(name: 'grand_total_value')
  final double grandTotalValue;
  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  @JsonKey(name: 'coupon_applied')
  final bool couponApplied;

  Cart({
    required this.items,
    required this.subTotal,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.grandTotal,
    required this.grandTotalValue,
    this.couponCode,
    this.couponApplied = false,
  });

  /// Creates a Cart instance from JSON
  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CartToJson(this);

  @override
  Cart copyWith({
    List<CartItem>? items,
    String? subTotal,
    String? tax,
    String? shippingCost,
    String? discount,
    String? grandTotal,
    double? grandTotalValue,
    String? couponCode,
    bool? couponApplied,
  }) {
    return Cart(
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      grandTotal: grandTotal ?? this.grandTotal,
      grandTotalValue: grandTotalValue ?? this.grandTotalValue,
      couponCode: couponCode ?? this.couponCode,
      couponApplied: couponApplied ?? this.couponApplied,
    );
  }

  /// Returns the total number of items in cart
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Returns true if cart has any items
  bool get hasItems => items.isNotEmpty;

  /// Returns true if cart has a discount applied
  bool get hasDiscount => double.parse(discount) > 0;

  /// Returns true if cart has shipping cost
  bool get hasShippingCost => double.parse(shippingCost) > 0;

  /// Returns true if cart has tax
  bool get hasTax => double.parse(tax) > 0;

  /// Returns the cart subtotal as double
  double get subTotalValue => double.parse(subTotal);

  /// Returns the tax value as double
  double get taxValue => double.parse(tax);

  /// Returns the shipping cost as double
  double get shippingCostValue => double.parse(shippingCost);

  /// Returns the discount value as double
  double get discountValue => double.parse(discount);

  /// Calculates savings (discount + coupon savings)
  double get totalSavings => discountValue;

  /// Returns items grouped by seller/store
  Map<int, List<CartItem>> get itemsByStore {
    return groupBy(items, (CartItem item) => item.ownerId);
  }
}

@JsonSerializable(explicitToJson: true)
class CartItem extends BaseModel with JsonHelperMixin {
  final int id;
  @JsonKey(name: 'owner_id')
  final int ownerId;
  final Product product;
  final int quantity;
  @JsonKey(name: 'unit_price')
  final String unitPrice;
  @JsonKey(name: 'tax')
  final String tax;
  @JsonKey(name: 'shipping_cost')
  final String shippingCost;
  @JsonKey(name: 'discount')
  final String discount;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;
  @JsonKey(defaultValue: {})
  final Map<String, String> variation;

  CartItem({
    required this.id,
    required this.ownerId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.price,
    required this.currencySymbol,
    this.variation = const {},
  });

  /// Creates a CartItem instance from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @override
  CartItem copyWith({
    int? id,
    int? ownerId,
    Product? product,
    int? quantity,
    String? unitPrice,
    String? tax,
    String? shippingCost,
    String? discount,
    String? price,
    String? currencySymbol,
    Map<String, String>? variation,
  }) {
    return CartItem(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      price: price ?? this.price,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      variation: variation ?? this.variation,
    );
  }

  /// Returns the unit price as double
  double get unitPriceValue => double.parse(unitPrice);

  /// Returns the tax value as double
  double get taxValue => double.parse(tax);

  /// Returns the shipping cost as double
  double get shippingCostValue => double.parse(shippingCost);

  /// Returns the discount value as double
  double get discountValue => double.parse(discount);

  /// Returns the total price as double
  double get priceValue => double.parse(price);

  /// Returns true if the item has variations
  bool get hasVariation => variation.isNotEmpty;

  /// Returns true if the item has a discount
  bool get hasDiscount => discountValue > 0;

  /// Returns true if the item has shipping cost
  bool get hasShippingCost => shippingCostValue > 0;

  /// Returns true if the item has tax
  bool get hasTax => taxValue > 0;

  /// Returns formatted price with currency symbol
  String get formattedPrice => '$currencySymbol$price';

  /// Returns formatted unit price with currency symbol
  String get formattedUnitPrice => '$currencySymbol$unitPrice';

  /// Returns variation as formatted string
  String get variationText {
    if (!hasVariation) return '';
    return variation.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
  }
}

/// Extension to add additional functionality to Cart
extension CartX on Cart {
  /// Returns true if free shipping threshold is met
  bool get qualifiesForFreeShipping {
    // Example threshold of 100
    const freeShippingThreshold = 100.0;
    return subTotalValue >= freeShippingThreshold;
  }

  /// Returns amount needed for free shipping
  double get amountAwayFromFreeShipping {
    const freeShippingThreshold = 100.0;
    if (qualifiesForFreeShipping) return 0;
    return freeShippingThreshold - subTotalValue;
  }

  /// Returns estimated delivery date range
  DateTimeRange get estimatedDeliveryRange {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.add(const Duration(days: 3)),
      end: now.add(const Duration(days: 7)),
    );
  }
}

/// Helper function to group list items
Map<T, List<S>> groupBy<S, T>(Iterable<S> items, T Function(S) key) {
  var groups = <T, List<S>>{};
  for (var item in items) {
    (groups[key(item)] ??= []).add(item);
  }
  return groups;
}

/// Date range class for delivery estimates
class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({required this.start, required this.end});
}
