#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <deque>
#include "tripole_nsec.h"
#include "subbus.h"
#include "sbwriter.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
  Q_OBJECT

public:
  explicit MainWindow(QWidget *parent = 0);
  ~MainWindow();
  // Subbus *sb;

public slots:
  void setCommand();
  void setEnable(bool on);

signals:
  void statusChanged(QString);

private:
  Ui::MainWindow *ui;
  QTimer poll;
  void setup_nsec(uint16_t addr, QLabel *lbl);
  std::deque<tripole_nsec*> nsecs;
  sbwriter sbw;
};

#endif // MAINWINDOW_H
