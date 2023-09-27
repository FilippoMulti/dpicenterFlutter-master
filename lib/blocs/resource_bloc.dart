import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dpicenter/models/server/dalle/response_model.dart';
import 'package:dpicenter/models/server/resource_query_model.dart';
import 'package:dpicenter/models/server/resource_response.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/server/dalle/input.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  //CancelableOperation? operation;
  final MultiService<ResourceResponse> service = MultiService<ResourceResponse>(
      ResourceResponse.fromJsonModel,
      apiName: 'Resource');

  ResourceBloc()
      : super(const ResourceInitState(
            event: ResourceEvent(status: ResourceEvents.idle))) {
    on<ResourceEvent>(
      (event, emit) async {
        try {
          switch (event.status) {
            case ResourceEvents.idle:
              emit(ResourceInitState(event: event));
              break;
            case ResourceEvents.fetchImagePreview:
              emit(ResourceInitState(event: event));
              ResourceQueryModel queryModel =
                  ResourceQueryModel(name: event.name!);
              //static const String _get = '/api/@name/get/';

              List<ResourceResponse>? imagesNameList =
                  await service.retrieveCommand(
                      '/api/Resource/getImagesNameList/',
                      queryModel,
                      ResourceResponse.fromJsonModel);

              if (imagesNameList != null) {
                List<ResourceResponse>? result = await service.retrieveCommand(
                    '/api/Resource/getImagePreview/',
                    queryModel,
                    ResourceResponse.fromJsonModel);
                if (result != null) {
                  /*    for (int index=0; index <result.length; index++){
                    result[index]=result[index].copyWith(decodedContents: base64Decode(result[index].contents!));
                  }*/
                  emit(ResourceFetchCompletedState(
                      event: event, nameList: imagesNameList, items: result));
                } else {
                  emit(ResourceError(
                      event: event,
                      error:
                          '/api/Resource/getImagePreview/ get null response'));
                }
              } else {
                emit(ResourceError(
                    event: event,
                    error:
                        '/api/Resource/getImagesNameList/ get null response'));
              }

              break;
            case ResourceEvents.fetchImage:
              emit(ResourceInitState(event: event));
              ResourceQueryModel queryModel =
                  ResourceQueryModel(name: event.name!);
              //static const String _get = '/api/@name/get/';

              List<ResourceResponse>? imagesNameList =
                  await service.retrieveCommand(
                      '/api/Resource/getImagesNameList/',
                      queryModel,
                      ResourceResponse.fromJsonModel);

              if (imagesNameList != null) {
                List<ResourceResponse>? result = await service.retrieveCommand(
                    '/api/Resource/getImage/',
                    queryModel,
                    ResourceResponse.fromJsonModel);
                if (result != null) {
                  /*        for (int index=0; index <result.length; index++){
                    result[index]=result[index].copyWith(decodedContents: base64Decode(result[index].contents!));
                  }*/

                  emit(ResourceFetchCompletedState(
                      event: event, nameList: imagesNameList, items: result));
                } else {
                  emit(ResourceError(
                      event: event,
                      error: '/api/Resource/getImage/ get null response'));
                }
              } else {
                emit(ResourceError(
                    event: event,
                    error:
                        '/api/Resource/getImagesNameList/ get null response'));
              }

              break;

            case ResourceEvents.fetchNameList:
              emit(ResourceInitState(event: event));
              //static const String _get = '/api/@name/get/';
              List<ResourceResponse>? result = await service.retrieveCommand(
                  '/api/Resource/getImagesNameList/',
                  null,
                  ResourceResponse.fromJsonModel);
              if (result != null) {
                emit(ResourceFetchCompletedState(
                    event: event, nameList: result, items: result));
              } else {
                emit(ResourceError(
                    event: event,
                    error:
                        '/api/Resource/getImagesNameList/ get null response'));
              }

              break;
            case ResourceEvents.generateImage:
              emit(ResourceInitState(event: event));

              ResourceQueryModel queryModel =
                  ResourceQueryModel(name: event.input ?? '');
              //static const String _get = '/api/@name/get/';

              //var service2 = MultiService<ResponseModel>(ResponseModel.fromJson, apiName: 'Resource');

              //List<ResponseModel>? responseModel = await service2.retrieveCommand('/api/Resource/generateImage', input, ResponseModel.fromJson);
              List<ResourceResponse>? responseModel =
                  await service.retrieveCommand('/api/Resource/generateImage',
                      queryModel, ResourceResponse.fromJson);

              if (responseModel != null && responseModel.isNotEmpty) {
                ResourceQueryModel queryModel =
                    ResourceQueryModel(name: responseModel.first.name);
                //static const String _get = '/api/@name/get/';

                List<ResourceResponse>? imagesNameList =
                    await service.retrieveCommand(
                        '/api/Resource/getImagesNameList/',
                        queryModel,
                        ResourceResponse.fromJsonModel);

                if (imagesNameList != null) {
                  emit(ResourceFetchCompletedState(
                      event: event,
                      nameList: imagesNameList,
                      items: responseModel));
                } else {
                  emit(ResourceError(
                      event: event,
                      error:
                          '/api/Resource/getImagesNameList/ get null response'));
                }
              } else {
                emit(ResourceError(
                    event: event,
                    error: '/api/Resource/generateImage/ get null response'));
              }

              break;
            default:
              break;
          }
        } on Exception catch (e) {
          if (kDebugMode) {
            print(e);
          }
          emit(ResourceError(event: event, error: e));
        }
      },

      /// Specify a custom event transformer from `package:bloc_concurrency`
      transformer: restartable(),
    );
  }
}
