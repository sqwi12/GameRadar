import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

Future<Response> onRequest(RequestContext context, String id) {
  final services = context.read<Services>();
  final user = context.read<AuthUser>();
  return byMethod(context, {
    HttpMethod.put: () => putWatchlistItem(context.request, services, user, id),
    HttpMethod.delete: () =>
        deleteWatchlistItem(context.request, services, user, id),
  });
}
