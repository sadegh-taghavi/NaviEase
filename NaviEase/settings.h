#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QTranslator>
#include <QFile>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniEnvironment>
#include <QtAndroidExtras/QAndroidJniObject>
#endif

class CSettings : public QObject
{
    Q_OBJECT
    QTranslator m_langTr;
    QByteArray  m_langBa;
public:
    static CSettings *m_settings;
    enum ActionDirection
    {
        AD_Disable = 0,
        AD_TurnToLeft_SwipeToLeft,
        AD_TurnToTop_SwipeToTop,
        AD_TurnToRight_SwipeToRight,
        AD_TurnToBottom_SwipeToBottom,
        AD_TwistRight_SwipeToForward,
        AD_TwistLeft_SwipeToBackward,
        AD_Count,
    };
    enum ActionState
    {
        AS_Back = 0,
        AS_Home,
        AS_Recents,
        AS_Notifications,
        AS_QuickSettings,
        AS_PowerDialog,
        AS_Count,
    };

    Q_ENUMS(ActionDirection)
    Q_ENUMS(ActionState)

#ifdef Q_OS_ANDROID

    static void actionDone(JNIEnv, jobject, jint action);
    static void valuesChanged(JNIEnv, jobject);
#endif
    explicit CSettings(QObject *parent = 0);

    Q_INVOKABLE float getActionSensitivity( int action );
    Q_INVOKABLE void setActionSensitivity( int action, float value );
    Q_INVOKABLE int getActionDirection( int action );
    Q_INVOKABLE void setActionDirection( int action, int value );
    Q_INVOKABLE int getActionVibrate( int action );
    Q_INVOKABLE void setActionVibrate( int action, int value );
    Q_INVOKABLE int getActionDelay( );
    Q_INVOKABLE void setActionDelay( int value );
    Q_INVOKABLE bool getActionGyroMode( );
    Q_INVOKABLE void setActionGyroMode( bool value );
    Q_INVOKABLE bool getActionDoubleEnable( );
    Q_INVOKABLE void setActionDoubleEnable( bool value );
    Q_INVOKABLE int getActionDoubleMinDelay( );
    Q_INVOKABLE void setActionDoubleMinDelay( int value );
    Q_INVOKABLE int getActionDoubleMaxDelay( );
    Q_INVOKABLE void setActionDoubleMaxDelay( int value );

    Q_INVOKABLE bool isGyroSupported( );
    Q_INVOKABLE void requestSettings();
    Q_INVOKABLE void loadSettings();
    Q_INVOKABLE void saveSettings();

    Q_INVOKABLE void setLanguege( bool english );


signals:
    void valuesChangedSignal();
    void actionDoneBackSignal();
    void actionDoneHomeSignal();
    void actionDoneRecentsSignal();
    void actionDoneNotificationsSignal();
    void actionDoneQuickSettingsSignal();
    void actionDonePowerDialogSignal();
public slots:

};

#endif // SETTINGS_H
