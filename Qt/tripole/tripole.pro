#-------------------------------------------------
#
# Project created by QtCreator 2016-09-09T11:30:45
#
#-------------------------------------------------

QT       += core gui serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = tripole
TEMPLATE = app


SOURCES += main.cpp\
    snprintf.cpp \
    mainwindow.cpp \
    subbus.cpp nl_verr.cpp \
    nl_error.cpp nldbg.cpp nlresp.cpp \
    ascii_esc.cpp \
    tripole_nsec.cpp \
    sbwriter.cpp

HEADERS  += mainwindow.h \
    subbus.h nortlib.h nl_assert.h \
    tripole_nsec.h \
    sbwriter.h

FORMS    += mainwindow.ui

DISTFILES +=
