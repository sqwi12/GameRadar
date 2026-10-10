import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

Future<Response> onRequest(RequestContext context) => byMethod(context, {
  HttpMethod.get: () => listWatchlist(
    context.request,
    context.read<Services>(),
    context.read<AuthUser>(),
  ),
});
