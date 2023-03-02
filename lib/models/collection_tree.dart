import 'package:shop/models/collection.dart';
import 'package:shop/models/collection_tree_item.dart';

class CollectionTree {
  List<CollectionTreeItem>? roots;

  CollectionTree();

  void getChildren(List<Collection> collectionList, CollectionTreeItem parent) {
    if (collectionList.any((element) => parent.id == element.parent)) {
      parent.children ??= [];

      collectionList
          .where((element) => parent.id == element.parent)
          .forEach((element) {
        parent.children!.add(CollectionTreeItem(element));
      });
    }

    if (parent.children != null) {
      for (var element in parent.children!) {
        getChildren(collectionList, element);
      }
    }
  }

  factory CollectionTree.fromCollectionList(List<Collection> collectionList) {
    CollectionTree tree = CollectionTree();
    tree.roots = collectionList
        .where((element) => element.parent == null)
        .map((e) => CollectionTreeItem(e))
        .toList();
    for (var element in tree.roots!) {
      tree.getChildren(collectionList, element);
    }
    return tree;
  }
}
