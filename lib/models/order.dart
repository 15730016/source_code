import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';
import 'package:active_ecommerce_cms_demo_app/models/cart.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order extends BaseModel with JsonHelperMixin {
  final int id;
  @JsonKey(name: 'code')
  final String orderCode;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'shipping_address')
  final ShippingAddress shippingAddress;
  @JsonKey(name: 'payment_type')
  final String paymentType;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'payment_details')
  final String? paymentDetails;
  @JsonKey(name: 'grand_total')
  final String grandTotal;
  @JsonKey(name: 'coupon_discount')
  final String couponDiscount;
  @JsonKey(name: 'shipping_cost')
  final String shippingCost;
  @JsonKey(name: 'subtotal')
  final String subtotal;
  @JsonKey(name: 'tax')
  final String tax;
  final String date;
  @JsonKey(name: 'delivery_status')
  final String deliveryStatus;
  @JsonKey(name: 'delivery_viewed')
  final bool deliveryViewed;
  @JsonKey(name: 'payment_status_viewed')
  final bool paymentStatusViewed;
  @JsonKey(name: 'commission_calculated')
  final bool commissionCalculated;
  final List<OrderItem> items;
  final List<OrderHistory> history;

  Order({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.shippingAddress,
    required this.paymentType,
    required this.paymentStatus,
    this.paymentDetails,
    required this.grandTotal,
    required this.couponDiscount,
    required this.shippingCost,
    required this.subtotal,
    required this.tax,
    required this.date,
    required this.deliveryStatus,
    required this.deliveryViewed,
    required this.paymentStatusViewed,
    required this.commissionCalculated,
    required this.items,
    required this.history,
  });

  /// Creates an Order instance from JSON
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  Order copyWith({
    int? id,
    String? orderCode,
    int? userId,
    ShippingAddress? shippingAddress,
    String? paymentType,
    String? paymentStatus,
    String? paymentDetails,
    String? grandTotal,
    String? couponDiscount,
    String? shippingCost,
    String? subtotal,
    String? tax,
    String? date,
    String? deliveryStatus,
    bool? deliveryViewed,
    bool? paymentStatusViewed,
    bool? commissionCalculated,
    List<OrderItem>? items,
    List<OrderHistory>? history,
  }) {
    return Order(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      userId: userId ?? this.userId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentType: paymentType ?? this.paymentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      grandTotal: grandTotal ?? this.grandTotal,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      shippingCost: shippingCost ?? this.shippingCost,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      date: date ?? this.date,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      deliveryViewed: deliveryViewed ?? this.deliveryViewed,
      paymentStatusViewed: paymentStatusViewed ?? this.paymentStatusViewed,
      commissionCalculated: commissionCalculated ?? this.commissionCalculated,
      items: items ?? this.items,
      history: history ?? this.history,
    );
  }

  /// Returns the grand total as double
  double get grandTotalValue => double.parse(grandTotal);

  /// Returns the coupon discount as double
  double get couponDiscountValue => double.parse(couponDiscount);

  /// Returns the shipping cost as double
  double get shippingCostValue => double.parse(shippingCost);

  /// Returns the subtotal as double
  double get subtotalValue => double.parse(subtotal);

  /// Returns the tax as double
  double get taxValue => double.parse(tax);

  /// Returns true if payment is completed
  bool get isPaymentCompleted => paymentStatus.toLowerCase() == 'paid';

  /// Returns true if order is delivered
  bool get isDelivered => deliveryStatus.toLowerCase() == 'delivered';

  /// Returns true if order is cancelled
  bool get isCancelled => deliveryStatus.toLowerCase() == 'cancelled';

  /// Returns true if order can be cancelled
  bool get canBeCancelled {
    return !isDelivered && 
           !isCancelled && 
           deliveryStatus.toLowerCase() != 'processing';
  }

  /// Returns true if order has coupon discount
  bool get hasCouponDiscount => couponDiscountValue > 0;

  /// Returns the order date as DateTime
  DateTime get orderDate => DateTime.parse(date);

  /// Returns the latest order status update
  OrderHistory? get latestUpdate => history.isNotEmpty ? history.last : null;

  /// Returns all order updates of a specific type
  List<OrderHistory> getUpdatesByType(String type) {
    return history.where((update) => update.type == type).toList();
  }
}

@JsonSerializable(explicitToJson: true)
class OrderItem extends BaseModel with JsonHelperMixin {
  final int id;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'product_name')
  final String productName;
  final String variation;
  final int quantity;
  @JsonKey(name: 'price')
  final String unitPrice;
  @JsonKey(name: 'tax')
  final String tax;
  @JsonKey(name: 'shipping_cost')
  final String shippingCost;
  @JsonKey(name: 'discount')
  final String discount;
  @JsonKey(name: 'total')
  final String total;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.variation,
    required this.quantity,
    required this.unitPrice,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => 
      _$OrderItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  OrderItem copyWith({
    int? id,
    int? productId,
    String? productName,
    String? variation,
    int? quantity,
    String? unitPrice,
    String? tax,
    String? shippingCost,
    String? discount,
    String? total,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      variation: variation ?? this.variation,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      total: total ?? this.total,
    );
  }
}

@JsonSerializable()
class OrderHistory extends BaseModel with JsonHelperMixin {
  final int id;
  final String type;
  final String status;
  final String? comment;
  @JsonKey(name: 'created_at')
  final String createdAt;

  OrderHistory({
    required this.id,
    required this.type,
    required this.status,
    this.comment,
    required this.createdAt,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => 
      _$OrderHistoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderHistoryToJson(this);

  @override
  OrderHistory copyWith({
    int? id,
    String? type,
    String? status,
    String? comment,
    String? createdAt,
  }) {
    return OrderHistory(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns the update date as DateTime
  DateTime get date => DateTime.parse(createdAt);
}

@JsonSerializable()
class ShippingAddress extends BaseModel with JsonHelperMixin {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String country;
  final String city;
  @JsonKey(name: 'postal_code')
  final String postalCode;

  ShippingAddress({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.country,
    required this.city,
    required this.postalCode,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => 
      _$ShippingAddressFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);

  @override
  ShippingAddress copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? country,
    String? city,
    String? postalCode,
  }) {
    return ShippingAddress(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      country: country ?? this.country,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  /// Returns the full address as a formatted string
  String get fullAddress {
    return '$address\n$city, $country\n$postalCode';
  }

  /// Returns true if the address is complete
  bool get isComplete {
    return name.isNotEmpty &&
           email.isNotEmpty &&
           phone.isNotEmpty &&
           address.isNotEmpty &&
           country.isNotEmpty &&
           city.isNotEmpty &&
           postalCode.isNotEmpty;
  }
}

/// Extension to add additional functionality to Order
extension OrderX on Order {
  /// Returns true if the order requires action (unviewed status changes)
  bool get requiresAction {
    return (!deliveryViewed && deliveryStatus.toLowerCase() != 'pending') ||
           (!paymentStatusViewed && paymentStatus.toLowerCase() != 'unpaid');
  }

  /// Returns the time elapsed since order was placed
  Duration get timeElapsed {
    return DateTime.now().difference(orderDate);
  }

  /// Returns estimated delivery date range
  DateTimeRange get estimatedDeliveryRange {
    // Example delivery estimate logic
    final processingDays = 1;
    final shippingDays = 3;
    
    final start = orderDate.add(Duration(days: processingDays));
    final end = start.add(Duration(days: shippingDays));
    
    return DateTimeRange(start: start, end: end);
  }

  /// Returns order status as a percentage
  double get progressPercentage {
    const statusWeights = {
      'pending': 0.0,
      'confirmed': 0.25,
      'processing': 0.5,
      'shipped': 0.75,
      'delivered': 1.0,
      'cancelled': 0.0,
    };
    
    return statusWeights[deliveryStatus.toLowerCase()] ?? 0.0;
  }
}
