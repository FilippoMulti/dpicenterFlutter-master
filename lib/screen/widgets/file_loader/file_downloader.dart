import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/file_global.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/take_picture/take_picture_screen.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;
import 'package:universal_html/html.dart' as html;

class MediaDownloader extends StatefulWidget {
  final Media mediaToDownload;
  final Function(Media? value)? onDownloaded;

  const MediaDownloader({
    Key? key,
    required this.mediaToDownload,
    this.onDownloaded,
  }) : super(key: key);

  @override
  MediaDownloaderState createState() => MediaDownloaderState();
}

class MediaDownloaderState extends State<MediaDownloader>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 150), () {
        _downloadFile();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _downloader();
  }

  _downloadFile() {
    var bloc = BlocProvider.of<ServerDataBloc<Media>>(context);
    bloc.add(ServerDataEvent<Media>(
        status: ServerDataEvents.fetch,
        queryModel: QueryModel(
            id: widget.mediaToDownload.mediaId.toString(),
            downloadContent: true)));
  }

  Widget _downloader() {
    return BlocListener<ServerDataBloc<Media>, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) {
      if (state.event is ServerDataLoaded) {
        Navigator.pop(context, state.event?.items);
      }
    }, child: BlocBuilder<ServerDataBloc<Media>, ServerDataState>(
            builder: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pop(context, state.items);
        });
        // return const Text("OK!");
      }
      return Container(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              pacman(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 16,
              ),
              if (state is ServerDataLoading)
                const Text("Download in corso..."),
              if (state is ServerDataLoadingSendProgress)
                Text(
                    "Richiesta ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
              if (state is ServerDataLoadingReceiveProgress)
                Text(
                    "Ricezione ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
              const SizedBox(
                height: 16,
              ),
              /* OkCancel(onCancel: (){
                if (mounted) {
                  Navigator.of(context).maybePop(null);
                }

              },)*/
            ],
          ),
        ),
      );
    }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
