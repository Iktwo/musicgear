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
    resources.qrc \
    translations.qrc

OTHER_FILES += \
    qml/*.js \
    qml/*.qml \
    bar-descriptor.xml \
    android/AndroidManifest.xml \
    android/src/com/iktwo/musicgear/MusicGear.java


include(deployment.pri)

TRANSLATIONS += translations/translation_es.ts

lupdate_only{
    SOURCES = qml/*.qml
}

DISTFILES += \
    android/res/values-v21/styles.xml \
    android/res/values/screen_data.xml \
    android/src/org/qtproject/qt5/android/bindings/QtActivity.java
