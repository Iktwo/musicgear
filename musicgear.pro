QT += core gui network xml phonon declarative

DEFINES += HARMATTAN_BOOSTER

SOURCES += \
    src/main.cpp \
    src/song.cpp \
    src/downloader.cpp \
    src/musicstreamer.cpp \
    src/audiocomponent.cpp

HEADERS += \
    src/song.h \
    src/downloader.h \
    src/musicstreamer.h \
    src/audiocomponent.h

OTHER_FILES += \
    qml/main.qml \
    qml/AboutDialog.qml \
    qml/MainPage.qml \
    qml/SearchPage.qml \
    qml/DownloadPage.qml \
    qml/TitleBar.qml \
    musicgear.conf \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog \
    qml/PlaylistDelegate.qml \
    qml/SearchDelegate.qml \
    qml/PlaylistPage.qml \
    qml/PlaybackControls.qml

RESOURCES += \
    resources.qrc

installPrefix = /opt/$${TARGET}
target.path = $${installPrefix}/bin

desktopfile.files = resources/$${TARGET}_harmattan.desktop
desktopfile.path = /usr/share/applications

icon.files = resources/$${TARGET}80.png
icon.path = /usr/share/icons/hicolor/80x80/apps

splash.files = resources/images/splash.png
splash.path = /usr/share/musicgear

gamecategory.files = resources/musicgear.conf
gamecategory.path = /usr/share/policy/etc/syspart.conf.d

INSTALLS += desktopfile icon files splash gamecategory target
