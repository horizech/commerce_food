import 'package:shop/models/collection.dart';

class CollectionTreeItem extends Collection {
  List<CollectionTreeItem>? children;

  CollectionTreeItem(Collection collection)
      : super(
          id: collection.id,
          createdOn: collection.createdOn,
          createdBy: collection.createdBy,
          lastUpdatedOn: collection.lastUpdatedOn,
          lastUpdatedBy: collection.lastUpdatedBy,
          name: collection.name,
          media: collection.media,
          parent: collection.parent,
        );
}
