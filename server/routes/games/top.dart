import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

Future<Response> onRequest(RequestContext context) => byMethod(context, {
  HttpMethod.get: () => topGames(context.request, context.read<Services>()),
});
