#ifndef AUDIOCOMPONENT_H
#define AUDIOCOMPONENT_H

#include <QObject>
#include <Phonon>

class AudioComponent : public QObject
{
    Q_OBJECT
    Q_ENUMS(PlaybackState)

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(qint64 currentTime READ currentTime NOTIFY currentTimeChanged)
    Q_PROPERTY(qint64 totalTime READ totalTime NOTIFY totalTimeChanged)
    Q_PROPERTY(PlaybackState playbackState READ playbackState NOTIFY playbackStateChanged)

public:
    explicit AudioComponent(QObject *parent = 0);

    enum PlaybackState {
        Loading,
        Stopped,
        Playing,
        Buffering,
        Paused,
        Error
    };

    QString source() const;
    void setSource(const QString &source);

    PlaybackState playbackState() const;

    qint64 totalTime() const;
    qint64 currentTime() const;

    Q_INVOKABLE void play() const;
    Q_INVOKABLE void pause() const;

signals:
    void sourceChanged();
    void totalTimeChanged();
    void playbackStateChanged();
    void currentTimeChanged();
    
private:
    QString m_source;
    Phonon::AudioOutput *m_audioOutput;
    Phonon::MediaObject *m_mediaObject;

private slots:
    void emitStateChanged(Phonon::State newstate, Phonon::State oldState);
    void tick(qint64 time);
    void emitTotalTimeChanged(qint64 time);
};

#endif // AUDIOCOMPONENT_H
