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
    sbwriter.cpp \
    status_report.cpp

HEADERS  += mainwindow.h \
    subbus.h nortlib.h nl_assert.h \
    tripole_nsec.h \
    sbwriter.h \
    status_report.h

FORMS    += mainwindow.ui

DISTFILES +=

#==========Deploy
win32: {
    TARGET_CUSTOM_EXT = .exe

    CONFIG( debug, debug|release ) {
        # debug
        DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/debug/$${TARGET}$${TARGET_CUSTOM_EXT}))
        DLLDESTDIR  = $$shell_quote($$shell_path($${OUT_PWD}/out/debug/))
    } else {
        # release
        DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/release/$${TARGET}$${TARGET_CUSTOM_EXT}))
        DLLDESTDIR  = $$shell_quote($$shell_path($${OUT_PWD}/out/release/))
    }

    DEPLOY_COMMAND = windeployqt
    QMAKE_POST_LINK = $${DEPLOY_COMMAND} --dir $${DLLDESTDIR} --no-translations $${DEPLOY_TARGET}
}
#==========================================
