TEMPLATE = app

QT += qml quick widgets xml svg bluetooth core

CONFIG += c++11

SOURCES += main.cpp \
    scanner.cpp

RESOURCES += qml.qrc

lupdate_only {
SOURCES = main.qml \
          MainForm.ui.qml
}
TRANSLATIONS = tietobtscanner_en.ts \
               tietobtscanner_zh.ts

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
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    scanner.h
