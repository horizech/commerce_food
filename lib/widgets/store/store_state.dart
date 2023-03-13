part of 'store_cubit.dart';

class StoreState {
  final bool isLoading;
  final bool isSuccessful;
  final bool isError;
  final String? error;
  final List<Collection>? collections;
  final CollectionTree? collectionTree;
  final List<Keyword>? keywords;
  final List<ProductOption>? productOptions;
  final List<ProductOptionValue>? productOptionValues;
  final List<Gallery>? gallery;
  final List<Restaurant>? restaurants;
  final List<ProductCombo>? productCombos;
  final List<Combo>? combos;
  final List<AddOn>? addOns;

  StoreState(
    this.isLoading,
    this.isSuccessful,
    this.isError,
    this.error,
    this.collections,
    this.collectionTree,
    this.keywords,
    // this.genders,
    this.productOptions,
    this.productOptionValues,
    this.gallery,
    this.restaurants,
    this.combos,
    this.productCombos,
    this.addOns,
  );

  get productOptionsValuesMod => null;
}
