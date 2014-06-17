QT += quick widgets network multimedia

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
    src/styler.cpp \
    src/musicstreamer.cpp

HEADERS += \
    src/song.h \
    src/downloader.h \
    src/styler.h \
    src/musicstreamer.h

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    qml/style.js \
    qml/TitleBarTextInput.qml \
    qml/TitleBarImageButton.qml \
    qml/TitleBar.qml \
    qml/SongDelegate.qml \
    qml/SearchDialog.qml \
    qml/PlaylistDelegate.qml \
    qml/MenuTextItem.qml \
    qml/Menu.qml \
    qml/MainPage.qml \
    qml/main.qml \
    qml/Label.qml \
    qml/ImageButton.qml \
    qml/Divider.qml \
    qml/Dialog.qml \
    bar-descriptor.xml \
    android/version.xml \
    android/AndroidManifest.xml \
    android/src/com/iktwo/utils/QDownloadManager.java \
    qml/PlaybackControls.qml

include(deployment.pri)
