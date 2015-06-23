TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    filestream.cpp \
    Base64.cpp \
    Password32.cpp

RESOURCES += qml.qrc


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    filestream.h \
    Base64.h \
    Password32.h
