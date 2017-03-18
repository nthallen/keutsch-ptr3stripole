#ifndef RFWINDOW_H
#define RFWINDOW_H

#include <QObject>
#include <QTimer>
#include <QWidget>
#include <QGridLayout>
#include <QLabel>
#include <QRadioButton>
#include <QMainWindow>
#include "rf_channel.h"
#include "tmsbvar.h"
#include "rf_sbtypes.h"

enum rfWindowState { ws_init, ws_looping, ws_acquire, ws_slow_poll };

class rfWindow : public QObject {
  Q_OBJECT
public:
  rfWindow();
  ~rfWindow();
  static const int label_col = 0;
  static const int cmd_col = 1;
  static const int set_col = 2;
  static const int unit_col = 3;
  static const int cmd2_col = 4;
  static const int set2_col = 5;
  static const int unit2_col = 6;
  static const int n_cols = 7;
  static const double xtal_freq;
  static const double clkA_M;
  static const double clkA_D;
  static const double clkB_M;
  static const int phase_bits;
public slots:
  void acquire();
  void init();
  void runcmdToggled(bool checked);
  void start_acquisition();
  void suspend_acquisition();
  void saveConfigs();
  void loadConfigs();
private:
  QLabel *colHeader(const char *label);
  void saveConfig(rf_channel *channel);
  void loadConfig(rf_channel *channel);
  QMainWindow *mainwindow;
  QWidget *window;
  QRadioButton *runcmd;
  QGridLayout *layout;
  rf_channel *period;
  rf_channel *delay[3];
  rf_channel *high[3];
  tmsbvar_run *runvar;
  tmsbvar_ilock *ilockvar;
  tmdispvar *rundisp, *ilockdisp;
  tmdispvar *mhz;
  int MFCtr;
  QLabel *MFCtrWidget;

  // rf_status *tmstat;
  QTimer poll;
  QLabel *status;
  rfWindowState state;
};

#endif // RFWINDOW_H
