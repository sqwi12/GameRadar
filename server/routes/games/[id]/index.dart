import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

Future<Response> onRequest(RequestContext context, String id) =>
    byMethod(context, {
      HttpMethod.get: () =>
          gameDetails(context.request, context.read<Services>(), id),
    });
