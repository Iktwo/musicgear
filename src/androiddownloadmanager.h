#ifndef ANDROIDDOWNLOADMANAGER_H
#define ANDROIDDOWNLOADMANAGER_H

#include <QObject>

class AndroidDownloadManager : public QObject
{
    Q_OBJECT
public:
    explicit AndroidDownloadManager(QObject *parent = 0);

    Q_INVOKABLE void downloadFile(const QString &url, const QString &fileName);

};

#endif // ANDROIDDOWNLOADMANAGER_H
