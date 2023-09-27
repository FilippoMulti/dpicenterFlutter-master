import 'dart:typed_data';

class SerialPort {
  final String name;
  static List<String> availablePorts = ['dummy'];
  static SerialPortError? lastError;

  SerialPort(this.name);

  bool openReadWrite() {
    return false;
  }

  /// Opens the serial port for reading only.
  bool openRead() {
    return false;
  }

  /// Gets whether the serial port is open.
  bool get isOpen {
    return false;
  }

  void close() {}
}

class SerialPortReader {
  SerialPort get port {
    // TODO: implement port
    throw UnimplementedError();
  }

  Stream<Uint8List> get stream {
    // TODO: implement stream
    throw UnimplementedError();
  }

  factory SerialPortReader(SerialPort port, {int? timeout}) =>
      SerialPortReader(port, timeout: timeout);

  void close() {}
}

class SerialPortError {}
