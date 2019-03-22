#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include "settings.h"

#ifdef Q_OS_ANDROID
#include <jni.h>
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniEnvironment>
#include <QtAndroidExtras/QAndroidJniObject>

jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    JNIEnv *env;

    if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_4) != JNI_OK)
        return JNI_FALSE;

    JNINativeMethod methods[] = {
                                {"actionDone", "(I)V", reinterpret_cast<void *>(CSettings::actionDone)},
                                {"valuesChanged", "()V", reinterpret_cast<void *>(CSettings::valuesChanged)}
                                };

    jclass clazz = env->FindClass("org/tdevelopers/naviease/CustomMainActivity");

    if (env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0])) < 0)
        return JNI_FALSE;

    return JNI_VERSION_1_4;
}

#endif

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("NaviEase");
    QGuiApplication::setOrganizationName("TDevelopers");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<CSettings>("org.tdevelopers.naviease", 1, 0, "CSettings");

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
