#include "rf_channel.h"
#include "tmdispvar.h"

rf_channel::rf_channel(const char *name, tmsbvar *var, QGridLayout *layout,
                       int row, int col, const char *label, const char *unit) {
  this->name = name;
  this->var = var;
  cmd = new QDoubleSpinBox();
  cmd->setAlignment(Qt::AlignRight);
  cmd->setKeyboardTracking(false);
  disp = new tmdispvar(var);
  var->setupSpin(cmd);
  connect(cmd,
    static_cast<void(QDoubleSpinBox::*)(double)>(&QDoubleSpinBox::valueChanged),
    this,&rf_channel::set);
  if (label) {
    this->label = new QLabel(label);
    layout->addWidget(this->label, row, col++);
    this->label->setAlignment(Qt::AlignRight);
  } else {
    this->label = 0;
  }
  layout->addWidget(cmd, row, col++);
  layout->addWidget(disp->widget, row, col++);
  if (unit) {
    this->unit = new QLabel(unit);
    layout->addWidget(this->unit, row, col++);
  } else {
    this->unit = 0;
  }
}

rf_channel::~rf_channel() {
  if (cmd) {
    delete cmd;
    cmd = 0;
  }
  if (disp) {
    delete disp;
    disp = 0;
  }
  if (var) {
    delete var;
    var = 0;
  }
  if (label) {
    delete label;
    label = 0;
  }
  if (unit) {
    delete unit;
    unit = 0;
  }
}

void rf_channel::set(double val) {
  uint16_t rawVal = var->unconvertValue(val);
  var->setRawValue(rawVal);
  cmd->setValue(var->convertedValue(rawVal));
}

void rf_channel::acquire() {
  var->acquire();
}
