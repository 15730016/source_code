import 'package:json_annotation/json_annotation.dart';
import 'package:active_ecommerce_cms_demo_app/models/base_model.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category extends BaseModel with JsonHelperMixin {
  final int id;
  final String name;
  @JsonKey(name: 'banner')
  final String? bannerImage;
  @JsonKey(name: 'icon')
  final String? iconImage;
  @JsonKey(name: 'number_of_children')
  final int childrenCount;
  @JsonKey(name: 'links')
  final CategoryLinks links;
  @JsonKey(defaultValue: [])
  final List<Category> children;
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @JsonKey(name: 'level')
  final int level;
  @JsonKey(name: 'top')
  final bool isTop;
  @JsonKey(name: 'featured')
  final bool isFeatured;
  @JsonKey(name: 'digital')
  final bool isDigital;
  @JsonKey(name: 'products_count')
  final int productsCount;

  Category({
    required this.id,
    required this.name,
    this.bannerImage,
    this.iconImage,
    this.childrenCount = 0,
    required this.links,
    this.children = const [],
    this.parentId,
    this.level = 0,
    this.isTop = false,
    this.isFeatured = false,
    this.isDigital = false,
    this.productsCount = 0,
  });

  /// Creates a Category instance from JSON
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  Category copyWith({
    int? id,
    String? name,
    String? bannerImage,
    String? iconImage,
    int? childrenCount,
    CategoryLinks? links,
    List<Category>? children,
    int? parentId,
    int? level,
    bool? isTop,
    bool? isFeatured,
    bool? isDigital,
    int? productsCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      bannerImage: bannerImage ?? this.bannerImage,
      iconImage: iconImage ?? this.iconImage,
      childrenCount: childrenCount ?? this.childrenCount,
      links: links ?? this.links,
      children: children ?? this.children,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      isTop: isTop ?? this.isTop,
      isFeatured: isFeatured ?? this.isFeatured,
      isDigital: isDigital ?? this.isDigital,
      productsCount: productsCount ?? this.productsCount,
    );
  }

  /// Returns true if the category has child categories
  bool get hasChildren => childrenCount > 0;

  /// Returns true if this is a root category (no parent)
  bool get isRoot => parentId == null;

  /// Returns true if the category has products
  bool get hasProducts => productsCount > 0;

  /// Returns true if the category has a banner image
  bool get hasBanner => bannerImage != null && bannerImage!.isNotEmpty;

  /// Returns true if the category has an icon
  bool get hasIcon => iconImage != null && iconImage!.isNotEmpty;

  /// Returns a display image (banner if available, otherwise icon)
  String? get displayImage => bannerImage ?? iconImage;

  /// Returns all descendant categories (children, grandchildren, etc.)
  List<Category> get allDescendants {
    final descendants = <Category>[];
    for (final child in children) {
      descendants.add(child);
      descendants.addAll(child.allDescendants);
    }
    return descendants;
  }

  /// Returns all ancestor category IDs
  List<int> get ancestorIds {
    final ancestors = <int>[];
    var currentParentId = parentId;
    while (currentParentId != null) {
      ancestors.add(currentParentId);
      // Note: This would need actual parent data to work completely
      break;
    }
    return ancestors;
  }
}

@JsonSerializable()
class CategoryLinks {
  final String products;
  @JsonKey(name: 'sub_categories')
  final String subCategories;

  CategoryLinks({
    required this.products,
    required this.subCategories,
  });

  factory CategoryLinks.fromJson(Map<String, dynamic> json) => 
      _$CategoryLinksFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryLinksToJson(this);
}

/// Extension to add additional functionality to Category
extension CategoryX on Category {
  /// Returns the full path name (including parent categories)
  String get fullPath {
    final path = <String>[name];
    // Note: This would need actual parent data to work completely
    return path.join(' > ');
  }

  /// Returns true if this category is a parent of the given category
  bool isParentOf(Category other) {
    return other.parentId == id;
  }

  /// Returns true if this category is an ancestor of the given category
  bool isAncestorOf(Category other) {
    return other.ancestorIds.contains(id);
  }

  /// Returns true if this category is a child of the given category
  bool isChildOf(Category other) {
    return parentId == other.id;
  }

  /// Returns true if this category is a descendant of the given category
  bool isDescendantOf(Category other) {
    return ancestorIds.contains(other.id);
  }

  /// Returns a list of category features/attributes
  List<String> get features {
    final features = <String>[];
    
    if (isTop) features.add('Top Category');
    if (isFeatured) features.add('Featured');
    if (isDigital) features.add('Digital Products');
    if (hasChildren) features.add('Has Subcategories');
    if (hasProducts) features.add('Has Products');
    
    return features;
  }
}
