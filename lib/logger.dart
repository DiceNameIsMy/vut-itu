import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    noBoxingByDefault: true,
  ),
);
