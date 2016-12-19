#include "mainwindow.h"
#include "nortlib.h"
#include "ui_mainwindow.h"
#include <QtSerialPort/QtSerialPort>
#include <QFile>
#include <QTextStream>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
  ui->setupUi(this);
  // sb = new Subbus();
  MFCtr = 0;
  connect(&Subbus_client::SB, &Subbus::statusChanged,
          ui->status_text, &QLabel::setText);
  connect(&Subbus_client::SB, &Subbus::subbus_initialized,
          this, &MainWindow::start_acquisition);
  connect(&Subbus_client::SB, &Subbus::subbus_closed,
          this, &MainWindow::suspend_acquisition);
  // Setup the tripole_nsec objects
  setup_nsec(0x21, ui->Period);
  setup_nsec(0x23, ui->PhaseADly);
  setup_nsec(0x22, ui->PhaseAHi);
  setup_nsec(0x25, ui->PhaseBDly);
  setup_nsec(0x24, ui->PhaseBHi);
  setup_nsec(0x27, ui->PhaseCDly);
  setup_nsec(0x26, ui->PhaseCHi);
  setup_status_report(0x20, ui->Enable, ui->Interlock);
  connect(&poll, &QTimer::timeout, this, &MainWindow::updateMFCtr);
  init();
}

MainWindow::~MainWindow()
{
  delete ui;
}

void MainWindow::setup_nsec(uint16_t addr, QLabel *lbl) {
  tripole_nsec *ns = new tripole_nsec(addr, lbl);
  ns->setParent(this);
  nsecs.push_back(ns);
  ui->cmdSelect->addItem(ns->getName(), nsecs.size()-1);
  connect(&poll, &QTimer::timeout, ns, &tripole_nsec::acquire);
}

void MainWindow::setup_status_report(uint16_t addr, QLabel *RunLbl, QLabel *FailLbl) {
  status_report *rpt = new status_report(addr, RunLbl, FailLbl);
  rpt->setParent(this);
  connect(&poll, &QTimer::timeout, rpt, &status_report::acquire);
}

void MainWindow::setEnable(bool on) {
  sbw.sbwrite(0x20, on ? 1 : 0);
}

void MainWindow::setCommand() {
  int nsec_idx = ui->cmdSelect->currentIndex();
  int nsec = ui->cmdValue->value();
//  Subbus_client::SB.statusChanged(
//        "Command index: " + QString::number(nsec_idx) + "\n"
//        + "Object: " + nsecs[nsec_idx]->getName() + "\n"
//        + "Value: " + QString::number(nsec)
//        );
  nsecs[nsec_idx]->set(nsec);
}

void MainWindow::saveFile() {
  // QString cwd = QDir::currentPath();
  // nl_error(0, "Save File Action: %s", cwd.toUtf8().constData());
  QFile data("tripole_init.dat");
  if (data.open(QFile::WriteOnly | QFile::Truncate)) {
    QTextStream out(&data);
    for (auto i = nsecs.begin(); i != nsecs.end(); ++i) {
      out << (*i)->getName() << " " << (*i)->getValue() << "\n";
    }
    data.close();
  } else {
    nl_error(2, "Unable to write to config file");
  }
}

void MainWindow::loadFile() {
  // QString cwd = QDir::currentPath();
  // nl_error(0, "Load File, CWD = %s", cwd.toUtf8().constData());
  QFile data("tripole_init.dat");
  if (data.open(QFile::ReadOnly)) {
    QTextStream in(&data);
    for (;;) {
      QString S;
      uint16_t val;
      in >> S >> val;
      if (S.isEmpty()) break;
      set_nsec(S, val);
      // nl_error(0, "Read %s: %d", S.toUtf8().constData(), val);
    }
    data.close();
  } else {
    nl_error(2, "Unable to read from config file");
  }
}

void MainWindow::set_nsec(QString name, uint16_t value) {
  for (auto i = nsecs.begin(); i != nsecs.end(); ++i) {
    if (name.compare((*i)->getName()) == 0) {
      (*i)->set(value);
      return;
    }
  }
  nl_error(2, "Unrecognized Variable: '%s'", name.toUtf8().constData());
}

void MainWindow::updateMFCtr() {
  ui->MFCtr->setNum(MFCtr++);
  if (MFCtr >= 65536) MFCtr = 0;
}

void MainWindow::init() {
  Subbus_client::SB.init();
  if (state != ws_slow_poll) {
    state = ws_slow_poll;
  }
}

void MainWindow::start_acquisition() {
  poll.stop();
  if (state != ws_acquire) {
    state = ws_acquire;
  }
  poll.setSingleShot(false);
  poll.start(250);
}

void MainWindow::suspend_acquisition() {
  poll.stop();
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
