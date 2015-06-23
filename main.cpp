#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "filestream.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<FileStream>("FileStream",1,0,"FileStream");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
