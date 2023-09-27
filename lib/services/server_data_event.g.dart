// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_data_event.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServerDataEventCWProxy<T> {
  ServerDataEvent<T> columnFilters(Map<String, Filter>? columnFilters);

  ServerDataEvent<T> command(dynamic Function(dynamic)? command);

  ServerDataEvent<T> customFilters(
      Map<String, bool Function(dynamic, dynamic)?>? customFilters);

  ServerDataEvent<T> item(T? item);

  ServerDataEvent<T> items(List<T>? items);

  ServerDataEvent<T> keyName(String? keyName);

  ServerDataEvent<T> onDataLoaded(dynamic Function(List<T>?)? onDataLoaded);

  ServerDataEvent<T> onEvent(
      dynamic Function(Bloc<dynamic, dynamic>, ServerDataEvent<dynamic>,
              Emitter<dynamic>)?
          onEvent);

  ServerDataEvent<T> queryModel(QueryModel? queryModel);

  ServerDataEvent<T> refresh(bool refresh);

  ServerDataEvent<T> status(ServerDataEvents? status);

  ServerDataEvent<T> withComplete(bool withComplete);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServerDataEvent<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServerDataEvent<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  ServerDataEvent<T> call({
    Map<String, Filter>? columnFilters,
    dynamic Function(dynamic)? command,
    Map<String, bool Function(dynamic, dynamic)?>? customFilters,
    T? item,
    List<T>? items,
    String? keyName,
    dynamic Function(List<T>?)? onDataLoaded,
    dynamic Function(
            Bloc<dynamic, dynamic>, ServerDataEvent<dynamic>, Emitter<dynamic>)?
        onEvent,
    QueryModel? queryModel,
    bool? refresh,
    ServerDataEvents? status,
    bool? withComplete,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServerDataEvent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServerDataEvent.copyWith.fieldName(...)`
class _$ServerDataEventCWProxyImpl<T> implements _$ServerDataEventCWProxy<T> {
  final ServerDataEvent<T> _value;

  const _$ServerDataEventCWProxyImpl(this._value);

  @override
  ServerDataEvent<T> columnFilters(Map<String, Filter>? columnFilters) =>
      this(columnFilters: columnFilters);

  @override
  ServerDataEvent<T> command(dynamic Function(dynamic)? command) =>
      this(command: command);

  @override
  ServerDataEvent<T> customFilters(
          Map<String, bool Function(dynamic, dynamic)?>? customFilters) =>
      this(customFilters: customFilters);

  @override
  ServerDataEvent<T> item(T? item) => this(item: item);

  @override
  ServerDataEvent<T> items(List<T>? items) => this(items: items);

  @override
  ServerDataEvent<T> keyName(String? keyName) => this(keyName: keyName);

  @override
  ServerDataEvent<T> onDataLoaded(dynamic Function(List<T>?)? onDataLoaded) =>
      this(onDataLoaded: onDataLoaded);

  @override
  ServerDataEvent<T> onEvent(
          dynamic Function(Bloc<dynamic, dynamic>, ServerDataEvent<dynamic>,
                  Emitter<dynamic>)?
              onEvent) =>
      this(onEvent: onEvent);

  @override
  ServerDataEvent<T> queryModel(QueryModel? queryModel) =>
      this(queryModel: queryModel);

  @override
  ServerDataEvent<T> refresh(bool refresh) => this(refresh: refresh);

  @override
  ServerDataEvent<T> status(ServerDataEvents? status) => this(status: status);

  @override
  ServerDataEvent<T> withComplete(bool withComplete) =>
      this(withComplete: withComplete);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServerDataEvent<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServerDataEvent<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  ServerDataEvent<T> call({
    Object? columnFilters = const $CopyWithPlaceholder(),
    Object? command = const $CopyWithPlaceholder(),
    Object? customFilters = const $CopyWithPlaceholder(),
    Object? item = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? keyName = const $CopyWithPlaceholder(),
    Object? onDataLoaded = const $CopyWithPlaceholder(),
    Object? onEvent = const $CopyWithPlaceholder(),
    Object? queryModel = const $CopyWithPlaceholder(),
    Object? refresh = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? withComplete = const $CopyWithPlaceholder(),
  }) {
    return ServerDataEvent<T>(
      columnFilters: columnFilters == const $CopyWithPlaceholder()
          ? _value.columnFilters
          // ignore: cast_nullable_to_non_nullable
          : columnFilters as Map<String, Filter>?,
      command: command == const $CopyWithPlaceholder()
          ? _value.command
          // ignore: cast_nullable_to_non_nullable
          : command as dynamic Function(dynamic)?,
      customFilters: customFilters == const $CopyWithPlaceholder()
          ? _value.customFilters
          // ignore: cast_nullable_to_non_nullable
          : customFilters as Map<String, bool Function(dynamic, dynamic)?>?,
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as T?,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<T>?,
      keyName: keyName == const $CopyWithPlaceholder()
          ? _value.keyName
          // ignore: cast_nullable_to_non_nullable
          : keyName as String?,
      onDataLoaded: onDataLoaded == const $CopyWithPlaceholder()
          ? _value.onDataLoaded
          // ignore: cast_nullable_to_non_nullable
          : onDataLoaded as dynamic Function(List<T>?)?,
      onEvent: onEvent == const $CopyWithPlaceholder()
          ? _value.onEvent
          // ignore: cast_nullable_to_non_nullable
          : onEvent as dynamic Function(Bloc<dynamic, dynamic>,
              ServerDataEvent<dynamic>, Emitter<dynamic>)?,
      queryModel: queryModel == const $CopyWithPlaceholder()
          ? _value.queryModel
          // ignore: cast_nullable_to_non_nullable
          : queryModel as QueryModel?,
      refresh: refresh == const $CopyWithPlaceholder() || refresh == null
          ? _value.refresh
          // ignore: cast_nullable_to_non_nullable
          : refresh as bool,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ServerDataEvents?,
      withComplete:
          withComplete == const $CopyWithPlaceholder() || withComplete == null
              ? _value.withComplete
              // ignore: cast_nullable_to_non_nullable
              : withComplete as bool,
    );
  }
}

extension $ServerDataEventCopyWith<T> on ServerDataEvent<T> {
  /// Returns a callable class that can be used as follows: `instanceOfServerDataEvent.copyWith(...)` or like so:`instanceOfServerDataEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServerDataEventCWProxy<T> get copyWith =>
      _$ServerDataEventCWProxyImpl<T>(this);
}
