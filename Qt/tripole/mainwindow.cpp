#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtSerialPort/QtSerialPort>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    sb = new Subbus();
    connect(sb, SIGNAL(statusChanged(QString)),
            ui->status_text, SLOT(setText(QString)));
}

MainWindow::~MainWindow()
{
  delete sb;
  delete ui;
}

int MainWindow::Start() {
  // Do something: Set another checkbox?
  // emit statusChanged("Hello\nWorld\nAm I scrolling yet?");
  sb->init();
  return 1;
}
