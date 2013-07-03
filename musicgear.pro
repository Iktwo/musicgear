QT += network xml

greaterThan(QT_MAJOR_VERSION, 4): QT += quick multimedia
else: QT += declarative

SOURCES += \
    src/main.cpp \
    src/song.cpp \
    src/downloader.cpp \
    src/downloadercomponent.cpp \
    src/styler.cpp

HEADERS += \
    src/song.h \
    src/downloader.h \
    src/downloadercomponent.h \
    src/styler.h

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    qml/QtQuick1/style.js \
    qml/QtQuick1/TitleBarTextInput.qml \
    qml/QtQuick1/TitleBarImageButton.qml \
    qml/QtQuick1/TitleBar.qml \
    qml/QtQuick1/SongDelegate.qml \
    qml/QtQuick1/SearchDialog.qml \
    qml/QtQuick1/PlaylistDelegate.qml \
    qml/QtQuick1/MenuTextItem.qml \
    qml/QtQuick1/Menu.qml \
    qml/QtQuick1/MainPage.qml \
    qml/QtQuick1/main.qml \
    qml/QtQuick1/Label.qml \
    qml/QtQuick1/ImageButton.qml \
    qml/QtQuick1/Divider.qml \
    qml/QtQuick1/Dialog.qml \
    qml/QtQuick1/Button.qml \
    qml/QtQuick2/style.js \
    qml/QtQuick2/TitleBarTextInput.qml \
    qml/QtQuick2/TitleBarImageButton.qml \
    qml/QtQuick2/TitleBar.qml \
    qml/QtQuick2/SongDelegate.qml \
    qml/QtQuick2/SearchDialog.qml \
    qml/QtQuick2/PlaylistDelegate.qml \
    qml/QtQuick2/MenuTextItem.qml \
    qml/QtQuick2/Menu.qml \
    qml/QtQuick2/MainPage.qml \
    qml/QtQuick2/main.qml \
    qml/QtQuick2/Label.qml \
    qml/QtQuick2/ImageButton.qml \
    qml/QtQuick2/Divider.qml \
    qml/QtQuick2/Dialog.qml \
    qml/QtQuick2/ToolBar.qml \
    bar-descriptor.xml \
    android/version.xml \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/qtproject/qt5/android/bindings/QtActivity.java \
    android/src/org/qtproject/qt5/android/bindings/QtApplication.java \
    android/res/layout/splash.xml \
    android/res/values-et/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-fa/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/values-it/strings.xml \
    android/res/values-ms/strings.xml \
    android/res/values-ja/strings.xml \
    android/res/values-rs/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/values-el/strings.xml \
    android/res/values-de/strings.xml \
    android/res/values-ru/strings.xml \
    android/res/values-zh-rCN/strings.xml \
    android/res/values/libs.xml \
    android/res/values/strings.xml \
    android/res/values-nb/strings.xml \
    android/res/values-zh-rTW/strings.xml \
    android/res/values-es/strings.xml \
    android/res/values-pl/strings.xml \
    android/AndroidManifest.xml
