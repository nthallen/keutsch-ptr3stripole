#ifndef RF_CHANNEL_H
#define RF_CHANNEL_H
#include <QDoubleSpinBox>
#include <QGridLayout>
#include "tmdispvar.h"
#include "tmsbvar.h"
#include "rf_channel.h"

class rf_channel : public QObject {
  Q_OBJECT
public:
  rf_channel(const char *name, tmsbvar *var, QGridLayout *layout,
             int row, int col, const char *label, const char *unit);
  ~rf_channel();
  const char *name;
  void set(double);
  void acquire();
  tmsbvar *var;
  QDoubleSpinBox *cmd;
  tmdispvar *disp;
  QLabel *label;
  QLabel *unit;
};

#endif // RF_CHANNEL_H
