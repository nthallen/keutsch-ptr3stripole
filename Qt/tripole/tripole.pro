#-------------------------------------------------
#
# Project created by QtCreator 2016-09-09T11:30:45
#
#-------------------------------------------------

QT       += core gui serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = QtW
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    subbus.cpp

HEADERS  += mainwindow.h \
    subbus.h

FORMS    += mainwindow.ui

DISTFILES +=
