// Copyright 2021 Sora Fukui. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

class Todo extends Equatable implements Entity<String> {
  final String id;
  final String name;

  const Todo(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

typedef Todos = Entities<String, Todo>;

void main() {
  test("todo", () {
    final todo1 = Todo("1", "todo1");
    final todo2 = Todo("2", "todo2");
    final todo3 = Todo("3", "todo3");

    final todos = Todos.empty();
    final putTodos = todos.put(todo1);
    print(putTodos);
    // Entities<String, Todo>(Todo(1, todo1))

    final putAllTodos = todos.putAll([todo1, todo2, todo3]);
    print(putAllTodos);
    // Entities<String, Todo>(Todo(1, todo1), Todo(2, todo2), Todo(3, todo3))

    final removeTodos = putAllTodos.remove(todo1);
    print(removeTodos);
    // Entities<String, Todo>(Todo(2, todo2), Todo(3, todo3))

    final removeAllTodos = putAllTodos.removeAll([todo1, todo2, todo3]);
    print(removeAllTodos);
    // Entities<String, Todo>()

    expect(todos == putTodos, false);
    expect(todos == putAllTodos, false);
    expect(putAllTodos == removeTodos, false);
    expect(removeAllTodos == putAllTodos, false);
  });

  test("sample", () {
    final todo1 = Todo("1", "todo1");
    final todo2 = Todo("2", "todo2");
    final todo3 = Todo("3", "todo3");

    final todos = Todos.empty();
    final putTodos = todos.put(todo1); // putTodos contain [todo1]

    final testPutTodos = (Todos todos) {
      expect(todos.length, 1);
      expect(todos.byId("1"), todo1);
    };
    testPutTodos(putTodos);

    final removedTodos = putTodos.remove(todo1); // removeTodos contain []

    final testRemovedTodos = (Todos todos) {
      expect(todos.length, 0);
      expect(todos.byId("1"), null);
    };
    testRemovedTodos(removedTodos);

    final putAllTodos = removedTodos.putAll([todo1, todo2, todo3]);

    final testPutAllTodos = (Todos todos) {
      expect(todos.length, 3);
      expect(todos.byId("1"), todo1);
      expect(todos.byId("2"), todo2);
      expect(todos.byId("3"), todo3);
    };
    testPutAllTodos(putAllTodos);

    final removeByIdTodos = putAllTodos.removeById("1");
    final testRemoveByIdTodos = (Todos todos) {
      expect(todos.length, 2);
      expect(todos.byId("1"), null);
      expect(todos.byId("2"), todo2);
      expect(todos.byId("3"), todo3);
    };
    testRemoveByIdTodos(removeByIdTodos);

    final removeAllTodos = removeByIdTodos.removeAll([todo1, todo2, todo3]);
    final testRemoveAllTodos = (Todos todos) {
      expect(todos.length, 0);
      expect(todos.byId("1"), null);
      expect(todos.byId("2"), null);
      expect(todos.byId("3"), null);
    };
    testRemoveAllTodos(removeAllTodos);

    testPutTodos(putTodos);
    testRemovedTodos(removedTodos);
    testPutAllTodos(putAllTodos);
    testRemoveByIdTodos(removeByIdTodos);
    testRemoveAllTodos(removeAllTodos);
  });
}
