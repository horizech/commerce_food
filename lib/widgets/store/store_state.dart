part of 'store_cubit.dart';

class StoreState {
  final bool isLoading;
  final bool isSuccessful;
  final bool isError;
  final String? error;
  final List<Collection>? collections;
  final CollectionTree? collectionTree;
  final List<Keyword>? keywords;
  final List<Attribute>? attributes;
  final List<AttributeValue>? attributeValues;
  final List<Gallery>? gallery;

  final List<ProductCombo>? productCombos;
  final List<Combo>? combos;
  final List<AddOn>? addOns;
  final List<ProductAttribute>? productAttributes;
  final List<OrderStatusType>? orderStatusType;

  StoreState(
    this.isLoading,
    this.isSuccessful,
    this.isError,
    this.error,
    this.collections,
    this.collectionTree,
    this.keywords,
    this.attributes,
    this.attributeValues,
    this.gallery,
    this.combos,
    this.productCombos,
    this.addOns,
    this.productAttributes,
    this.orderStatusType,
  );

  get productOptionsValuesMod => null;
}
