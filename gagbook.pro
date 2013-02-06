TEMPLATE = app
TARGET = gagbook

VERSION = 0.3.0
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

QT += network webkit

HEADERS += \
    src/qmlutils.h \
    src/gagmodel.h \
    src/gagobject.h \
    src/gagrequest.h \
    src/settings.h

SOURCES += main.cpp \
    src/qmlutils.cpp \
    src/gagmodel.cpp \
    src/gagobject.cpp \
    src/gagrequest.cpp \
    src/settings.cpp

# Simulator
simulator{
    folder_01.source = qml/gagbook-harmattan
    folder_01.target = qml
    folder_02.source = qml/gagbook-symbian
    folder_02.target = qml
    DEPLOYMENTFOLDERS = folder_01 folder_02

    HEADERS += src/shareui.h
    SOURCES += src/shareui.cpp
    RESOURCES += resource.qrc
}

# MeeGo Harmattan
contains(MEEGO_EDITION,harmattan) {
    folder_01.source = qml/gagbook-harmattan
    folder_01.target = qml
    DEPLOYMENTFOLDERS = folder_01

    HEADERS += src/shareui.h
    SOURCES += src/shareui.cpp

    CONFIG += shareuiinterface-maemo-meegotouch share-ui-plugin share-ui-common mdatauri qdeclarative-boostable
    DEFINES += Q_OS_HARMATTAN

    splash.files = splash/gagbook-splash-portrait.jpg splash/gagbook-splash-landscape.jpg
    splash.path = /opt/$${TARGET}/splash
    INSTALLS += splash
}

# Symbian^3
symbian{
    folder_01.source = qml/gagbook-symbian
    folder_01.target = qml
    DEPLOYMENTFOLDERS = folder_01

    # This is a self-signed UID
    TARGET.UID3 = 0xA00158E4

    CONFIG += qt-components
    TARGET.CAPABILITY += NetworkServices
    ICON = gagbook-symbian.svg
    RESOURCES += resource.qrc

    vendorinfo += "%{\"Dickson\"}" ":\"Dickson\""
    my_deployment.pkg_prerules = vendorinfo
    DEPLOYMENT += my_deployment
    DEPLOYMENT.display_name += GagBook

    # Symbian have a different syntax
    DEFINES -= APP_VERSION=\\\"$$VERSION\\\"
    DEFINES += APP_VERSION=\"$$VERSION\"
}

OTHER_FILES += qtc_packaging/debian_harmattan/* \
    gagbook_harmattan.desktop \
    README.md

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
