// services/notification/websocket_events.dart

/// أسماء أحداث الـ Socket.IO بمكان واحد، حتى تتفادى الأخطاء الإملائية
/// (زي 'noify' بدل 'notify') وتصير القيمة موحّدة بين الفرونت والباك.
class SocketEvents {
  SocketEvents._();

  // أحداث النظام الأساسية (تأتي من مكتبة socket_io_client نفسها)
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String error = 'error';

  // أحداث خاصة بالتطبيق (لازم تتطابق حرفياً مع أسماء emit بالباك إند)
  static const String notify = 'notify';
  static const String requestAccepted = 'requestAccepted';
  static const String verifyAccepted = 'VerifyAccepted';
  static const String studentSelectedOverseer = 'studentSelectedOverseer';
  static const String updateCaseType = 'updatecasetype';
  static const String sendMessage = 'send_message';

  // أحداث نرسلها نحن للسيرفر (emit)
  static const String registerPatient = 'registerPatient';
}
