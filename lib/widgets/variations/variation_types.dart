enum VariationTypes {
  size,
  color,
}

String getVariationTypePascal(VariationTypes type) {
  switch (type) {
    case VariationTypes.color:
      return "Color";
    case VariationTypes.size:
    default:
      return "Size";
  }
}
