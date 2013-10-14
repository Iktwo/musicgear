#include "audiocomponent.h"

#include <QDebug>

AudioComponent::AudioComponent(QObject *parent) :
    QObject(parent)
{
    m_audioOutput = new Phonon::AudioOutput(Phonon::MusicCategory, this);
    m_mediaObject = new Phonon::MediaObject(this);

    Phonon::createPath(m_mediaObject, m_audioOutput);

    m_mediaObject->setTickInterval(1000);

    connect(m_mediaObject, SIGNAL(tick(qint64)), SLOT(tick(qint64)));

    connect(m_mediaObject, SIGNAL(stateChanged(Phonon::State, Phonon::State)),
            SLOT(emitStateChanged(Phonon::State, Phonon::State)));

    connect(m_mediaObject, SIGNAL(totalTimeChanged(qint64)), SLOT(emitTotalTimeChanged(qint64)));

    //connect(mediaObject, SIGNAL(aboutToFinish()), SLOT(aboutToFinish()));
}

QString AudioComponent::source() const
{
    return m_source;
}

void AudioComponent::setSource(const QString &source)
{
    if (m_source == source)
        return;

    m_mediaObject->stop();
    m_mediaObject->setCurrentSource(source);
    //m_mediaObject->clearQueue();

    m_source = source;
    emit  sourceChanged();
    //m_mediaObject->enqueue(m_source);
}

AudioComponent::PlaybackState AudioComponent::playbackState() const
{
    return PlaybackState(m_mediaObject->state());
}

void AudioComponent::play() const
{
    qDebug() << "Requested play";
    m_mediaObject->play();
}

void AudioComponent::pause() const
{
    if (m_mediaObject->state() == Phonon::PausedState)
        m_mediaObject->play();
    else
        m_mediaObject->pause();
}

qint64 AudioComponent::currentTime() const
{
    return m_mediaObject->currentTime();
    //return m_mediaObject->
}

void AudioComponent::tick(qint64 time)
{
    Q_UNUSED(time)
    emit currentTimeChanged();
}

void AudioComponent::emitStateChanged(Phonon::State newstate, Phonon::State oldState)
{
    Q_UNUSED(newstate)
    Q_UNUSED(oldState)
    //qDebug() << "New state: " << newstate;
    emit playbackStateChanged();
}

qint64 AudioComponent::totalTime() const
{
    return m_mediaObject->totalTime();
}

void AudioComponent::emitTotalTimeChanged(qint64 time)
{
    Q_UNUSED(time)

    emit totalTimeChanged();
}
