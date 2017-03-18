#include <QApplication>
#include <QSettings>
#include <QFile>
#include "rfWindow.h"

int main(int argc, char *argv[])
{
  QApplication app(argc, argv);

  QFile styleFile( ":/style/RF.qss" );
  styleFile.open( QFile::ReadOnly );
  QString style( styleFile.readAll() );
  app.setStyleSheet( style );

  QSettings::setDefaultFormat(QSettings::IniFormat);
  QCoreApplication::setOrganizationName("HarvardKeutschGroup");
  QCoreApplication::setApplicationName("PTR3_RF");

  rfWindow *window = new rfWindow();
  return app.exec();
}
