#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtSerialPort/QtSerialPort>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
  ui->setupUi(this);
  // sb = new Subbus();
  connect(&Subbus_client::SB, &Subbus::statusChanged,
          ui->status_text, &QLabel::setText);
  // Setup the tripole_nsec objects
  setup_nsec(0x21, ui->Period);
  setup_nsec(0x23, ui->PhaseADly);
  setup_nsec(0x22, ui->PhaseAHi);
  setup_nsec(0x25, ui->PhaseBDly);
  setup_nsec(0x24, ui->PhaseBHi);
  setup_nsec(0x27, ui->PhaseCDly);
  setup_nsec(0x26, ui->PhaseCHi);
  Subbus_client::SB.init();
  poll.setSingleShot(false);
  poll.start(1000);
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
