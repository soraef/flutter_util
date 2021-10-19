// Copyright 2021 Sora Fukui. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:equatable/equatable.dart';

import 'entity.dart';

class Entities<Id, E extends Entity<Id>> extends Equatable {
  final Map<Id, E> _entities;

  const Entities(this._entities);

  factory Entities.empty() => Entities<Id, E>(const {});

  factory Entities.fromIterable(Iterable<E> entities) {
    return Entities<Id, E>({for (final entity in entities) entity.id: entity});
  }

  Iterable<E> get entities => _entities.values;

  Iterable<Id> get ids => _entities.keys;

  int get length => entities.length;

  bool exist(Id id) => _entities[id] != null;

  E? byId(Id id) => _entities[id];

  List<E> byIds(List<Id> ids) {
    return ids.where((id) => exist(id)).map((id) => byId(id)!).toList();
  }

  Entities<Id, E> put(E entity) {
    return Entities<Id, E>({..._entities, entity.id: entity});
  }

  Entities<Id, E> putAll(Iterable<E> entities) {
    return Entities<Id, E>({
      ..._entities,
      for (final entity in entities) entity.id: entity,
    });
  }

  Entities<Id, E> remove(E entity) {
    return Entities<Id, E>(
      {..._entities}..removeWhere((id, _) => id == entity.id),
    );
  }

  Entities<Id, E> removeAll(Iterable<E> entities) {
    return Entities<Id, E>(
      {..._entities}..removeWhere(
          (id, entity) => entities.map((e) => e.id).contains(id),
        ),
    );
  }

  Entities<Id, E> removeById(Id id) {
    return Entities<Id, E>(
      {..._entities}..removeWhere((_id, entity) => id == _id),
    );
  }

  Entities<Id, E> marge(Entities<Id, E> other) {
    return Entities<Id, E>({..._entities, ...other._entities});
  }

  Entities<Id, E> where(bool Function(E) test) {
    return Entities.fromIterable(_entities.values.where(test));
  }

  @override
  List<Object?> get props => entities.toList();
}
