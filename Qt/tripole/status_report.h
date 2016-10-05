#ifndef STATUS_REPORT_H
#define STATUS_REPORT_H
#include <QLabel>
#include <QString>
#include "subbus.h"

enum bool_display { bool_blank, bool_false, bool_true };

class status_report : public QObject, public Subbus_client {
  Q_OBJECT
public:
  status_report(uint16_t addr, QLabel *Run, QLabel *Fail);
  ~status_report();
  void ready();
  QString getName();
public slots:
  void acquire();
private:
  void DisplayStatus(uint16_t value,uint16_t mask,QLabel *QL,
                     enum bool_display &disp,const char *false_text,
                     const char *true_text);
  uint16_t addr;
  QLabel *RunQL;
  QLabel *FailQL;
  bool read_pending;
  enum bool_display RunVal;
  enum bool_display FailVal;
};

#endif // STATUS_REPORT_H
