#include "subbus.h"

Subbus::Subbus() {
  port = 0;
}

Subbus::~Subbus() {
  if (port) {
    delete(port);
    port = 0;
  }
}

void Subbus::init() {
  if (port) {
    emit statusChanged("Serial port already opened");
    return;
  }
  const auto infos = QSerialPortInfo::availablePorts();
  int nports = infos.size();
  QString s = "nports = " + QString::number(nports) + "\n";
  for (const auto info : infos) {
    s += info.portName() + " Mfr: " + info.manufacturer();
    if (info.isBusy()) {
      s += " Busy\n";
    } else if (portName.isEmpty()){
      portName = info.portName();
      s += " *\n";
    } else {
      s += "\n";
    }
  }
  if (portName.isEmpty()) {
    s += "No free serial port located";
  } else {
    port = new QSerialPort(portName);
    if (port->open(QIODevice::ReadWrite)) {
      s += "Opened successfully: baud=" +
          QString::number(port->baudRate()) + "\n";
      int nflush = 0;
      while (port->bytesAvailable()) {
        char buf[80];
        int nb = port->bytesAvailable();
        if (nb > 79) nb = 79;
        nflush += port->read(buf, nb);
      }
      if (nflush > 0) s += "Flushed " + QString::number(nflush) + " bytes\n";
      port->write("V\n");
      char version[80];
      int ver_len = 0;
      while (ver_len == 0 || (ver_len > 0 && version[ver_len-1] != '\n')) {
        if (port->waitForReadyRead(100)) {
          int nc = port->read(version+ver_len,79-ver_len);
          while (nc > 0) {
            if (version[ver_len++] == '\n') {
              version[ver_len] = '\0';
              s += version;
              break;
            }
            --nc;
          }
        } else {
          s += "Timed out reading version\n";
          break;
        }
      }
    } else {
      s += "Error " + QString::number(port->error()) + " on open";
      delete port;
      port = 0;
    }
  }
  emit statusChanged(s);
}
