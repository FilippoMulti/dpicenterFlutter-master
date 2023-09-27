import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';

part 'server_data_event.g.dart';

@CopyWith()
class ServerDataEvent<T> extends Equatable {
  final T? item;
  final List<T>? items;
  final bool withComplete;
  final ServerDataEvents? status;
  final Map<String, Filter>? columnFilters;
  final bool refresh;
  final QueryModel? queryModel;
  final String? keyName;
  final Map<String, bool Function(dynamic searchValue, dynamic item)?>?
      customFilters;
  final Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onEvent;
  final Function(List<T>? items)? onDataLoaded;
  final dynamic Function(dynamic)? command;

  const ServerDataEvent(
      {this.item,
      this.status,
      this.items,
      this.withComplete = false,
      this.refresh = true,
      this.columnFilters,
      this.customFilters,
      this.onEvent,
      this.onDataLoaded,
      this.queryModel,
      this.command,
      this.keyName});

  @override
  List<Object?> get props => [
        item,
        status,
        items,
        withComplete,
        refresh,
        columnFilters,
        customFilters,
        command,
      ];
}
