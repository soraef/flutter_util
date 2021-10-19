# entities

Provide utility classes to operate entities in an immutable way.

## This Package
The Entity is defined as a class with an Id, as shown below.

```dart
abstract class Entity<Id> {
  Id get id;
}
```

This package provides the Entities class, which is a set of Entity.
Entities is an immutable class that has a convenient API.

## How to Use
The first step is to define a class that implements Entity.

```dart
class Todo implements Entity<String> {
  final String id;
  final String name;

  const Todo(this.id, this.name);
}
```

Then optionally give an alias to Entities. 

```dart
typedef Todos = Entities<String, Todo>;
```

You are now ready to immutably manage a set of Entity.

This example makes available the Todos class, which has methods to add and remove Todo immutably.

You can define a todo set from `Todos.empty()`.

```dart
final todo1 = Todo("1", "todo1");
final todo2 = Todo("2", "todo2");
final todo3 = Todo("3", "todo3");

final todos = Todos.empty();
```

You can use the `put(Todo todo)` method to get a new Todos with todo added.

```dart
final putTodos = todos.put(todo1);
print(putTodos);
// Entities<String, Todo>(Todo(1, todo1))
```

You can add multiple todo at the same time with the `putAll(Iterable<Todo> todo)` method.

```dart
final putAllTodos = todos.putAll([todo1, todo2, todo3]);
print(putAllTodos);
// Entities<String, Todo>(Todo(1, todo1), Todo(2, todo2), Todo(3, todo3))
```

The `remove(Todo todo)` method removes the todo, and you get new todos.

```dart
final removeTodos = putAllTodos.remove(todo1);
print(removeTodos);
// Entities<String, Todo>(Todo(2, todo2), Todo(3, todo3))
```

The `removeAll(Iterable<Todo> todo)` method allows you to remove multiple todo at the same time.

```dart
final removeAllTodos = putAllTodos.removeAll([todo1, todo2, todo3]);
print(removeAllTodos);
// Entities<String, Todo>()
```

Since these methods are immutable, the new todos will be a different object than the original todos.

```dart
expect(todos == putTodos, false);
expect(todos == putAllTodos, false);
expect(putAllTodos == removeTodos, false);
expect(removeAllTodos == putAllTodos, false);
```
