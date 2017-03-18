QT += widgets serialport

CONFIG += c++11

TARGET = RF
# CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    nortlib/ascii_esc.cpp \
    nortlib/nl_error.cpp \
    nortlib/nl_verr.cpp \
    nortlib/nldbg.cpp \
    nortlib/nlresp.cpp \
    nortlib/snprintf.cpp \
    subbus/sbwriter.cpp \
    subbus/subbus.cpp \
    rf/rfWindow.cpp \
    rf/tmdispvar.cpp \
    rf/tmsbvar.cpp \
    rf/rf_channel.cpp \
    rf/rf_sbtypes.cpp

HEADERS += \
    nortlib/nl_assert.h \
    nortlib/nortlib.h \
    subbus/sbwriter.h \
    subbus/subbus.h \
    rf/rfWindow.h \
    rf/rf_channel.h \
    rf/tmdispvar.h \
    rf/tmsbvar.h \
    rf/rf_sbtypes.h

INCLUDEPATH = nortlib subbus rf

RESOURCES += \
    RF.qrc
