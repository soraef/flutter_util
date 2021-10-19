// Copyright 2021 Sora Fukui. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

class Item extends Equatable implements Entity<String> {
  final String id;
  final String name;

  const Item(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

typedef Items = Entities<String, Item>;

void main() {
  test("sample", () {
    final item1 = Item("1", "item1");
    final item2 = Item("2", "item2");
    final item3 = Item("3", "item3");

    final items = Items.empty();
    final putItems = items.put(item1); // putItems contain [item1]

    final testPutItems = (Items items) {
      expect(items.length, 1);
      expect(items.byId("1"), item1);
    };
    testPutItems(putItems);

    final removedItems = putItems.remove(item1); // removeItems contain []

    final testRemovedItems = (Items items) {
      expect(items.length, 0);
      expect(items.byId("1"), null);
    };
    testRemovedItems(removedItems);

    final putAllItems = removedItems.putAll([item1, item2, item3]);

    final testPutAllItems = (Items items) {
      expect(items.length, 3);
      expect(items.byId("1"), item1);
      expect(items.byId("2"), item2);
      expect(items.byId("3"), item3);
    };
    testPutAllItems(putAllItems);

    final removeByIdItems = putAllItems.removeById("1");
    final testRemoveByIdItems = (Items items) {
      expect(items.length, 2);
      expect(items.byId("1"), null);
      expect(items.byId("2"), item2);
      expect(items.byId("3"), item3);
    };
    testRemoveByIdItems(removeByIdItems);

    final removeAllItems = removeByIdItems.removeAll([item1, item2, item3]);
    final testRemoveAllItems = (Items items) {
      expect(items.length, 0);
      expect(items.byId("1"), null);
      expect(items.byId("2"), null);
      expect(items.byId("3"), null);
    };
    testRemoveAllItems(removeAllItems);

    testPutItems(putItems);
    testRemovedItems(removedItems);
    testPutAllItems(putAllItems);
    testRemoveByIdItems(removeByIdItems);
    testRemoveAllItems(removeAllItems);
  });
}
