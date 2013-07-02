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
    qml/QtQuick2/Button.qml \
    qml/QtQuick2/ToolBar.qml \
    bar-descriptor.xml
