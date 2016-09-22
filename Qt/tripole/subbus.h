#ifndef SUBBUS_H
#define SUBBUS_H
#include <QtSerialPort/QtSerialPort>
#include <QtSerialPort/QSerialPortInfo>

class Subbus : public QObject {

  Q_OBJECT

public:
  Subbus();
  ~Subbus();
  void init();

signals:
  void statusChanged(QString);

private:
  QString portName;
  QSerialPort *port;
};

#endif // SUBBUS_H
