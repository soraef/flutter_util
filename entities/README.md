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



