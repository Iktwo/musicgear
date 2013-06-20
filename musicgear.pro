QT += quick network xml multimedia

SOURCES += \
    src/main.cpp \
    src/song.cpp \
    src/downloader.cpp \
    src/downloadercomponent.cpp

HEADERS += \
    src/song.h \
    src/downloader.h \
    src/downloadercomponent.h

OTHER_FILES += \
    qml/main.qml \
    qml/MainPage.qml \
    qml/SongDelegate.qml \
    bar-descriptor.xml \
    qml/SearchDialog.qml \
    qml/PlaylistDelegate.qml

RESOURCES += \
    resources.qrc
