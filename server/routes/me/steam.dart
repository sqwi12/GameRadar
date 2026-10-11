import 'package:dart_frog/dart_frog.dart';
import 'package:gameradar_server/gameradar_server.dart';

Future<Response> onRequest(RequestContext context) {
  final services = context.read<Services>();
  final user = context.read<AuthUser>();
  return byMethod(context, {
    HttpMethod.get: () => getSteamLink(context.request, services, user),
    HttpMethod.put: () => putSteamLink(context.request, services, user),
    HttpMethod.delete: () => deleteSteamLink(context.request, services, user),
  });
}
