import 'dart:convert';
import 'dart:io';

void setOp(Map paths, String p, String method, String id) {
  final op = (paths[p]?[method] as Map?)?..['operationId'] = id;
  if (op == null) stderr.writeln('Skip $method $p: not found');
}

void main() async {
  final src = File('schemes/openapi.json');
  final dst = File('schemes/openapi.patched.json');

  final root = jsonDecode(await src.readAsString()) as Map<String, dynamic>;
  final paths = root['paths'] as Map<String, dynamic>;

  setOp(paths, '/api/v1/auth/login', 'post', 'login');
  setOp(paths, '/api/v1/auth/refresh', 'post', 'refreshTokens');
  setOp(paths, '/api/v1/auth/logout', 'post', 'logout');
  setOp(paths, '/api/v1/users/me', 'get', 'getMyProfile');

  await dst.writeAsString(const JsonEncoder.withIndent('  ').convert(root));
  print('Wrote ${dst.path}');
}
