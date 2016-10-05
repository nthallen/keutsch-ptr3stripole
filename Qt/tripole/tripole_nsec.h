#ifndef TRIPOLE_NSEC_H
#define TRIPOLE_NSEC_H
#include <QLabel>
#include <QString>
#include "subbus.h"

class tripole_nsec : public QObject, public Subbus_client {
  Q_OBJECT
public:
  tripole_nsec(uint16_t addr, QLabel *lbl);
  ~tripole_nsec();
  void ready();
  QString getName();
  uint16_t getValue();
public slots:
  void acquire();
  void set(int nsec); // converts nsec to raw
private:
  uint16_t addr;
  QLabel *QO;
  bool write_pending;
  uint16_t pending_value; // converted from nset to raw
  uint16_t current_value; // converted from raw to nsec
  bool read_pending;
};

#endif // TRIPOLE_NSEC_H
