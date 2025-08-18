import 'dart:async';

class RefreshController {
  static final StreamController<void> _controller = StreamController<void>.broadcast();

  static Stream<void> get stream => _controller.stream;

  static void refresh() {
    _controller.add(null); // kirim event
  }

  static void dispose() {
    _controller.close();
  }
}