import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:shop/models/collection_tree_item.dart';

List<TreeNode<CollectionTreeItem>>? getTreeSubNodes(CollectionTreeItem item) {
  if (item.children != null && item.children!.isNotEmpty) {
    List<TreeNode<CollectionTreeItem>>? subNodes = item.children!.map((e) {
      if (e.children != null && e.children!.isNotEmpty) {
        return TreeNode<CollectionTreeItem>(e,
            subNodes: getTreeSubNodes(e) ?? []);
      } else {
        return TreeNode<CollectionTreeItem>(e);
      }
    }).toList();
    return subNodes;
  } else {
    return null;
  }
}
