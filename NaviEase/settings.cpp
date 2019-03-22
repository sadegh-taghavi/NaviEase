#include "settings.h"
#include <QGuiApplication>
#include <QLocale>
#include <QDebug>

CSettings *CSettings::m_settings = NULL;

#ifdef Q_OS_ANDROID
void CSettings::actionDone(JNIEnv, jobject, jint action)
{
    if( !m_settings )
        return;
    switch( (int)action )
    {
    case AS_Back:
        emit m_settings->actionDoneBackSignal();
        break;
    case AS_Home:
        emit m_settings->actionDoneHomeSignal();
        break;
    case AS_Recents:
        emit m_settings->actionDoneRecentsSignal();
        break;
    case AS_Notifications:
        emit m_settings->actionDoneNotificationsSignal();
        break;
    case AS_QuickSettings:
        emit m_settings->actionDoneQuickSettingsSignal();
        break;
    case AS_PowerDialog:
        emit m_settings->actionDonePowerDialogSignal();
        break;
    };
}

void CSettings::valuesChanged(JNIEnv, jobject)
{
    if( !m_settings )
        return;
    emit m_settings->valuesChangedSignal();
}

#endif

CSettings::CSettings(QObject *parent) : QObject(parent)
{
    QFile file(":/lang.qm");
    file.open(QFile::ReadOnly);
    m_langBa = file.readAll();
    file.close();
    m_langTr.load( (const uchar *)m_langBa.data(), m_langBa.length() );
    setLanguege( ( QLocale::system().language() != QLocale::Persian ) );
    m_settings = this;
}

float CSettings::getActionSensitivity( int action )
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jfloat>("getActionSensitivity", "(I)F", action);
#else
    Q_UNUSED(action);
    return 0;
#endif
}

void CSettings::setActionSensitivity( int action, float value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionSensitivity","(IF)V", action, value);
#else
    Q_UNUSED(action);
    Q_UNUSED( value );
#endif
}

int CSettings::getActionDirection( int action )
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jint>("getActionDirection", "(I)I", action );
#else
    Q_UNUSED(action);
    return 0;
#endif
}

void CSettings::setActionDirection( int action, int value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionDirection","(II)V", action, value);
#else
    Q_UNUSED(action);
    Q_UNUSED( value );
#endif
}

int CSettings::getActionVibrate( int action )
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jint>("getActionVibrate", "(I)I", action);
#else
    Q_UNUSED(action);
    return 0;
#endif
}

void CSettings::setActionVibrate( int action, int value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionVibrate","(II)V",action, value);
#else
    Q_UNUSED(action);
    Q_UNUSED( value );
#endif
}

int CSettings::getActionDelay()
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jint>("getActionDelay");
#else
    return 0;
#endif
}

void CSettings::setActionDelay( int value )
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionDelay","(I)V", value);
#else
    Q_UNUSED( value );
#endif
}


bool CSettings::getActionGyroMode()
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jboolean>("getActionGyroMode");
#else
    return 0;
#endif
}

void CSettings::setActionGyroMode(bool value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionGyroMode","(Z)V", value);
#else
    Q_UNUSED( value );
#endif
}


bool CSettings::getActionDoubleEnable()
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jboolean>("getActionDoubleEnable");
#else
    return 0;
#endif
}

void CSettings::setActionDoubleEnable(bool value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionDoubleEnable","(Z)V", value);
#else
    Q_UNUSED( value );
#endif
}

int CSettings::getActionDoubleMinDelay()
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jint>("getActionDoubleMinDelay");
#else
    return 0;
#endif
}

void CSettings::setActionDoubleMinDelay(int value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionDoubleMinDelay","(I)V", value);
#else
    Q_UNUSED( value );
#endif
}

int CSettings::getActionDoubleMaxDelay()
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jint>("getActionDoubleMaxDelay");
#else
    return 0;
#endif
}

void CSettings::setActionDoubleMaxDelay(int value)
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("setActionDoubleMaxDelay","(I)V", value);
#else
    Q_UNUSED( value );
#endif
}

bool CSettings::isGyroSupported()
{
#ifdef Q_OS_ANDROID
    return QtAndroid::androidActivity().callMethod<jboolean>("isGyroSupported");
#else
    return true;
#endif
}


void CSettings::requestSettings()
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("requestSettings");
#else
    emit m_settings->valuesChangedSignal();
#endif
}

void CSettings::loadSettings()
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("loadSettings");
#endif
}

void CSettings::saveSettings()
{
#ifdef Q_OS_ANDROID
    QtAndroid::androidActivity().callMethod<void>("saveSettings");
#endif
}

void CSettings::setLanguege(bool english)
{
    if( english )
        qApp->removeTranslator( &m_langTr );
    else
        qApp->installTranslator( &m_langTr );
}
