#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "scanner.h"

static QObject *tieto_bt_scanner_provider(QQmlEngine *engine,
                                          QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    Scanner *scanner = new Scanner();
    return scanner;
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QTranslator qtTranslator;
    qtTranslator.load("tietobtscanner_" + QLocale::system().name(), ":/i18n/");
    app.installTranslator(&qtTranslator);

    QQmlApplicationEngine engine;
    qmlRegisterSingletonType<Scanner>("tieto.project.scanner", 1, 0, "BTScanner",
                                      tieto_bt_scanner_provider);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
