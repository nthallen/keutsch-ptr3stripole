#ifndef TMSBVAR_H
#define TMSBVAR_H

#include <QObject>
#include <QString>
#include <QDoubleSpinBox>
#include "subbus.h"

/**
 * @brief The tmsbvar class
 * acquire() enqueues a read request. If no read has completed
 * valueUpdated(false) is emitted. When a read is completed,
 * valueUpdated(true) is emitted.
 */
class tmsbvar : public QObject, public Subbus_client {
  Q_OBJECT
public:
  tmsbvar(uint16_t addr);
  ~tmsbvar();
  virtual void acquire();
  void ready();
  uint16_t rawValue();
  double convertedValue();
  void setRawValue(uint16_t rawValue);
  void setConvertedValue(double convValue);
  QString convertedText();
  virtual uint16_t unconvertValue(double conv_value);
  virtual double convertedValue(uint16_t raw_value);
  virtual QString convertedText(uint16_t raw_value);
  virtual void setupSpin(QDoubleSpinBox *cmd);

signals:
  void valueUpdated(bool);

protected:
  uint16_t value;
  uint16_t wValue;
private:
  uint16_t address;
  bool fresh;
  bool read_pending;
  bool write_pending;
  bool read_queued;
  bool write_queued;
};

#endif // TMSBVAR_H
