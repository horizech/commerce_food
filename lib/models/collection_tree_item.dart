import 'package:shop/models/collection.dart';

class CollectionTreeItem extends Collection {
  List<CollectionTreeItem>? children;

  CollectionTreeItem(Collection collection)
      : super(
          collection.id,
          collection.createdOn,
          collection.createdBy,
          collection.lastUpdatedOn,
          collection.lastUpdatedBy,
          collection.name,
          collection.media,
          collection.parent,
        );
}
