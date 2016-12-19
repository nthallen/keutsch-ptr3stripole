#include "mainwindow.h"
#include <QApplication>
#include <QSettings>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QSettings::setDefaultFormat(QSettings::IniFormat);
    QCoreApplication::setOrganizationName("HarvardKeutschGroup");
    QCoreApplication::setApplicationName("PTR3_RF");

    MainWindow w;
    w.show();

    return a.exec();
}
