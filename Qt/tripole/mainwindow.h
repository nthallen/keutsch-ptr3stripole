#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "subbus.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
  Q_OBJECT

public:
  explicit MainWindow(QWidget *parent = 0);
  ~MainWindow();
  Subbus *sb;

public slots:
  int Start();

signals:
  void statusChanged(QString);

private:
  Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
