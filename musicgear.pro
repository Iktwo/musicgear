QT += quick network xml multimedia

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

OTHER_FILES += \
    qml/main.qml \
    qml/MainPage.qml \
    qml/SongDelegate.qml \
    bar-descriptor.xml \
    qml/SearchDialog.qml \
    qml/PlaylistDelegate.qml \
    qml/style.js \
    qml/TitleBarTextInput.qml \
    qml/TitleBarImageButton.qml \
    qml/TitleBar.qml \
    qml/MenuTextItem.qml \
    qml/Menu.qml \
    qml/Label.qml \
    qml/ImageButton.qml \
    qml/DownloadPage.qml \
    qml/Divider.qml \
    qml/Dialog.qml \
    qml/Button.qml

RESOURCES += \
    resources.qrc
