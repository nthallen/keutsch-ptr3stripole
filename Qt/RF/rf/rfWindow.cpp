#include <QApplication>
#include <QMessageBox>
#include <QMainWindow>
#include <QMenuBar>
#include <QMenu>
#include <QAction>
#include "rfWindow.h"
#include "subbus.h"
#include "tmsbvar.h"
#include "rf_channel.h"

const double rfWindow::xtal_freq = 12e6;
const double rfWindow::clkA_M = 58.5;
const double rfWindow::clkA_D = 4.625;
const double rfWindow::clkB_M = 7;
const int rfWindow::phase_bits = 9;

rfWindow::rfWindow() {
  state = ws_init;
  mainwindow = new QMainWindow;
  window = new QWidget;
  mainwindow->setCentralWidget(window);
  layout = new QGridLayout;
  status = new QLabel("Start");
  status->setObjectName("status");
  int row = 0;
  runcmd = new QRadioButton("Run:", window);
  layout->addWidget(runcmd,row,label_col,Qt::AlignRight);
  runvar = new tmsbvar_run(0x20);
  rundisp = new tmdispvar(runvar);
  layout->addWidget(rundisp->widget,row,cmd_col);
  period = new rf_channel("period", new tmsbvar_ns_lowres(0x21), layout, row++, unit_col, "Period:", "ns");
  ilockvar = new tmsbvar_ilock(runvar);
  ilockdisp = new tmdispvar(ilockvar);
  mhz = new tmdispvar(new tmsbvar_mhz(period->var));
  layout->addWidget(mhz->widget,row,set2_col);
  layout->addWidget(new QLabel("MHz"),row,unit2_col);
  layout->addWidget(new QLabel("Interlock:"),row,label_col);
  layout->addWidget(ilockdisp->widget,row++,cmd_col);
  layout->addWidget(colHeader("Delay"),row,cmd_col,1,2);
  layout->addWidget(colHeader("High"),row++,cmd2_col,1,2);
  delay[0] = new rf_channel("delayA",new tmsbvar_ns_hires(0x23,false), layout, row, label_col, "Phase A:", "ns");
  high[0] = new rf_channel("highA",new tmsbvar_ns_lowres(0x22), layout, row++, cmd2_col, 0, "ns");
  delay[1] = new rf_channel("delayB",new tmsbvar_ns_hires(0x25), layout, row, label_col, "Phase B:", "ns");
  high[1] = new rf_channel("highB",new tmsbvar_ns_lowres(0x24), layout, row++, cmd2_col, 0, "ns");
  delay[2] = new rf_channel("delayC",new tmsbvar_ns_hires(0x27), layout, row, label_col, "Phase C:", "ns");
  high[2] = new rf_channel("highC",new tmsbvar_ns_lowres(0x26), layout, row++, cmd2_col, 0, "ns");
  MFCtr = 0;
  MFCtrWidget = new QLabel();
  layout->addWidget(new QLabel("MFCtr:"),row,cmd2_col,Qt::AlignRight);
  layout->addWidget(MFCtrWidget,row++,set2_col,Qt::AlignRight);
  layout->addWidget(status,row,0,1,n_cols);

  connect(runcmd, &QRadioButton::toggled, this, &rfWindow::runcmdToggled);
  connect(&Subbus_client::SB, &Subbus::statusChanged,
          status, &QLabel::setText);
  connect(&Subbus_client::SB, &Subbus::subbus_initialized,
          this, &rfWindow::start_acquisition);
  connect(&Subbus_client::SB, &Subbus::subbus_closed,
          this, &rfWindow::suspend_acquisition);
  window->setLayout(layout);

  QMenuBar *menuBar = mainwindow->menuBar();
  QMenu *configmenu = menuBar->addMenu("Config");
  QAction *saveaction = configmenu->addAction("Save");
  QAction *loadaction = configmenu->addAction("Load");
  connect(saveaction,&QAction::triggered,this,&rfWindow::saveConfigs);
  connect(loadaction,&QAction::triggered,this,&rfWindow::loadConfigs);

  mainwindow->show();
  init();
  state = ws_looping;
}

rfWindow::~rfWindow() {}

QLabel *rfWindow::colHeader(const char *label) {
  QLabel *widget = new QLabel(label);
  widget->setObjectName("colHeader");
  widget->setAlignment(Qt::AlignCenter);
  return widget;
}

void rfWindow::acquire() {
  MFCtrWidget->setText(QString::number(MFCtr));
  MFCtr = (MFCtr >= 65535) ? 0 : MFCtr+1;

  runvar->acquire();
  period->acquire();
  for (int i=0; i < 3; ++i) {
    delay[i]->acquire();
    high[i]->acquire();
  }
}

void rfWindow::runcmdToggled(bool checked) {
  runvar->setRawValue(checked ? 1 : 0);
}

void rfWindow::init() {
  Subbus_client::SB.init();
  if (state != ws_slow_poll) {
    state = ws_slow_poll;
  }
}

void rfWindow::start_acquisition() {
  poll.stop();
  if (state == ws_slow_poll) {
    disconnect(&poll, &QTimer::timeout, this, &rfWindow::init);
  }
  if (state != ws_acquire) {
    connect(&poll, &QTimer::timeout, this, &rfWindow::acquire);
    state = ws_acquire;
  }
  poll.setSingleShot(false);
  poll.start(500);
}

void rfWindow::suspend_acquisition() {
  poll.stop();
  if (state == ws_acquire) {
    disconnect(&poll, &QTimer::timeout, this, &rfWindow::acquire);
  }
  if (state != ws_slow_poll) {
    state = ws_slow_poll;
  }
  QMessageBox::StandardButton response =
    QMessageBox::warning(0, "Serial Connection",
                         "Serial Port Initialization Failed",
                       QMessageBox::Abort|QMessageBox::Retry);
  if (response == QMessageBox::Abort) {
    if (state == ws_looping) {
      QApplication::quit();
    } else {
      exit(0);
    }
  } else {
    init();
  }
}

void rfWindow::saveConfig(rf_channel *channel) {
  QSettings settings;
  settings.setValue(channel->name, channel->var->convertedText());
}

void rfWindow::saveConfigs() {
  QSettings settings;
  saveConfig(period);
  for (int i = 0; i < 3; ++i) {
    saveConfig(delay[i]);
    saveConfig(high[i]);
  }
  settings.sync();
}

void rfWindow::loadConfig(rf_channel *channel) {
  QSettings settings;
  if (settings.contains(channel->name)) {
    double value = settings.value(channel->name).toDouble();
    channel->var->setConvertedValue(value);
    channel->cmd->setValue(value);
  }
}

void rfWindow::loadConfigs() {
  loadConfig(period);
  for (int i = 0; i < 3; ++i) {
    loadConfig(delay[i]);
    loadConfig(high[i]);
  }
}
