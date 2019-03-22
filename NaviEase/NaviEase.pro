QT += quick quickcontrols2

android {
    QT += androidextras
}

CONFIG += c++11

SOURCES += main.cpp \
    settings.cpp

RESOURCES += qml.qrc

lupdate_only {
  SOURCES = *.qml \
            *.js \
  }

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/org/tdevelopers/naviease/CustomMainActivity.java \
    android/src/org/tdevelopers/naviease/MyAccessibilityService.java \
    android/res/xml/accessibilityservice.xml \
    android/libs/android-support-v4.jar \
    android/res/values/strings.xml \
    android/res/values-fa/libs.xml \
    android/res/values-fa/strings.xml \
    android/libs/adad-client-3.1.jar

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    settings.h
