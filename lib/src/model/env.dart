import '../enum/mode_type.dart';
import 'mode.dart';

class Env {
  static Mode sandbox =
      Mode(name: ModeType.sandbox, url: "https://sandbox-api-d.squadco.com");

  static Mode live =
      Mode(name: ModeType.live, url: "https://api-d.squadco.com");
}
