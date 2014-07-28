QT += quick widgets network multimedia

DEFINES += BUILD_DATE=\\\"$$system(date '+%d/%m/%Y')\\\"

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

!qnx {
    QT += svg
}

android {
    QT += androidextras

    SOURCES += \
    src/androiddownloadmanager.cpp

    HEADERS += \
    src/androiddownloadmanager.h
}

SOURCES += \
    src/main.cpp \
    src/song.cpp \
    src/downloader.cpp \
    src/musicstreamer.cpp \
    src/uivalues.cpp

HEADERS += \
    src/song.h \
    src/downloader.h \
    src/musicstreamer.h \
    src/uivalues.h

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    qml/*.js \
    qml/*.qml \
    bar-descriptor.xml \
    android/AndroidManifest.xml \
    android/src/com/iktwo/musicgear/MusicGear.java

include(deployment.pri)
