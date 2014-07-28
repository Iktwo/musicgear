#include "svgif.h"

#include <QFileInfo>
#include <QSettings>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QtGui/qpa/qplatformnativeinterface.h>
#include <QApplication>
#endif

#ifdef Q_OS_ANDROID
static void nativeOpenFile(JNIEnv *env, jobject thiz, jstring filename, jstring type, jlong qtObject)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    reinterpret_cast<Svgif*>(qtObject)->emitOpenFile(Svgif::jstringToQString(filename), Svgif::jstringToQString(type));
}
#endif

Svgif::Svgif(QObject *parent) :
    QObject(parent)
{
#ifdef Q_OS_ANDROID
    // Get external storage
    QAndroidJniObject mediaDir = QAndroidJniObject::callStaticObjectMethod("android/os/Environment", "getExternalStorageDirectory", "()Ljava/io/File;");
    // Get media path
    QAndroidJniObject mediaPath = mediaDir.callObjectMethod("getAbsolutePath", "()Ljava/lang/String;");
    QString dataAbsPath = mediaPath.toString();

    QAndroidJniObject cameraDirectory = QAndroidJniObject::getStaticObjectField<jstring>("android/os/Environment", "DIRECTORY_DCIM");
    QAndroidJniObject picturesDirectory = QAndroidJniObject::getStaticObjectField<jstring>("android/os/Environment", "DIRECTORY_PICTURES");
    QAndroidJniObject downloadsDirectory = QAndroidJniObject::getStaticObjectField<jstring>("android/os/Environment", "DIRECTORY_DOWNLOADS");

    m_initialData = jstringToQString(QAndroidJniObject::getStaticObjectField("com/iktwo/svgif/Svgif",
                                                                             "initialData",
                                                                             "Ljava/lang/String;").object<jstring>());

    m_initialDataType = jstringToQString(QAndroidJniObject::getStaticObjectField("com/iktwo/svgif/Svgif",
                                                                                 "initialDataType",
                                                                                 "Ljava/lang/String;").object<jstring>());

    m_paths.append(dataAbsPath + "/" + picturesDirectory.toString());
    m_paths.append(dataAbsPath + "/" + cameraDirectory.toString());
    m_paths.append(dataAbsPath + "/" + downloadsDirectory.toString());
#else
    m_paths.append(QDir::homePath() + "/Pictures");
#endif

    foreach (QString dirName, m_paths) {
        scanDir(QDir(dirName));
    }

    registerNatives();

    QSettings settings;
    m_showGifProgress = settings.value("showGifProgress", true).toBool();
}

void Svgif::rescan()
{
    m_model.clear();
    emit modelChanged();

    foreach (QString dirName, m_paths) {
        scanDir(QDir(dirName));
    }
}

QStringList Svgif::model() const
{
    return m_model;
}

void Svgif::setModel(const QStringList &model)
{
    if (m_model == model)
        return;

    m_model = model;
    emit modelChanged();
}

QStringList Svgif::paths() const
{
    return m_paths;
}

void Svgif::setPaths(const QStringList &paths)
{
    if (m_paths == paths)
        return;

    m_paths = paths;
    emit pathsChanged();
}

QString Svgif::initialData() const
{
    return m_initialData;
}

void Svgif::setInitialData(const QString &initialData)
{
    if (m_initialData == initialData)
        return;

    m_initialData = initialData;
    emit initialDataChanged();
}

QString Svgif::initialDataType() const
{
    return m_initialDataType;
}

void Svgif::setInitialDataType(const QString &initialDataType)
{
    if (m_initialDataType == initialDataType)
        return;

    m_initialDataType = initialDataType;
    emit initialDataTypeChanged();
}

bool Svgif::showGifProgress() const
{
    return m_showGifProgress;
}

void Svgif::setShowGifProgress(bool showGifProgress)
{
    if (m_showGifProgress == showGifProgress)
        return;

    m_showGifProgress = showGifProgress;
    emit showGifProgressChanged();

    QSettings settings;
    settings.setValue("showGifProgress", m_showGifProgress);
}

void Svgif::registerNatives()
{
#ifdef Q_OS_ANDROID
    JNINativeMethod methods[] {
        {"jOpenFile", "(Ljava/lang/String;Ljava/lang/String;J)V",
            reinterpret_cast<void *>(nativeOpenFile)}
    };

    QAndroidJniEnvironment env;
    QPlatformNativeInterface *interface = QApplication::platformNativeInterface();
    jobject activity = (jobject)interface->nativeResourceForIntegration("QtActivity");
    jclass clazz = env->GetObjectClass(activity);

    QAndroidJniObject::callStaticMethod<void>("com/iktwo/svgif/Svgif",
                                              "setQtObject", "(J)V", (jlong)reinterpret_cast<long>(this));

    if(env->ExceptionOccurred()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return;
    }

    env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0]));

    if(env->ExceptionOccurred()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return;
    }

    env->DeleteLocalRef(clazz);
#endif
}

#ifdef Q_OS_ANDROID
QString Svgif::jstringToQString(jstring string)
{
    QAndroidJniEnvironment env;
    jboolean jfalse = false;
    return QString(env->GetStringUTFChars(string, &jfalse));
}
#endif

void Svgif::scanDir(QDir dir)
{
    //    qDebug() << "LISTING DIR: " << dir.absolutePath();

    QStringList filters;
    filters << "*.gif" << "*.svg" << "*.GIF" << "*.SVG";

    foreach (QString filename, dir.entryList(filters, QDir::Files | QDir::NoDotAndDotDot | QDir::NoSymLinks)) {
        m_model.append(dir.absolutePath() + "/" + filename);
        emit modelChanged();
    }

    foreach (QString dirname, dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot | QDir::NoSymLinks)) {
        scanDir(QDir(dir.absolutePath() + "/" + dirname));
    }
}

void Svgif::emitOpenFile(const QString &filename, const QString &type)
{
    if (filename.startsWith("file://"))
        emit openFile(filename);
    else if (filename.startsWith("content://")) {
        QFile tempFile;
        if (type == "text/plain")
            tempFile.setFileName("temp.svg");
        else if (type == "image/gif")
            tempFile.setFileName("temp.gif");

#ifdef Q_OS_ANDROID
        if (tempFile.open(QIODevice::WriteOnly)) {
            QAndroidJniObject appIcon = QAndroidJniObject::callStaticObjectMethod("com/iktwo/svgif/Svgif",
                                                                                  "getImageData",
                                                                                  "(Ljava/lang/String;)[B",
                                                                                  QAndroidJniObject::fromString(filename).object<jstring>());

            QAndroidJniEnvironment env;
            jbyteArray iconDataArray = appIcon.object<jbyteArray>();

            if (!iconDataArray) {
                qDebug() << Q_FUNC_INFO << "No icon data";
                return;
            }

            jsize iconSize = env->GetArrayLength(iconDataArray);

            if (iconSize > 0) {
                jboolean jfalse = false;
                jbyte *icon = env->GetByteArrayElements(iconDataArray, &jfalse);

                tempFile.write(QByteArray::fromRawData((char*)icon, iconSize));
                env->ReleaseByteArrayElements(iconDataArray, icon, JNI_ABORT);
            }
        }

        emit openFile("file://" + QFileInfo(tempFile).absoluteFilePath());
#endif
    }
}
