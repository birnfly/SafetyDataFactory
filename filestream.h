#ifndef FILESTREAM_H
#define FILESTREAM_H

#include <QObject>
#include <QtCore/QStringList>

class FileStream : public QObject
{
    Q_OBJECT

protected:
    void getFileList(QString path,QString type,QStringList* list);

public:
    explicit FileStream(QObject *parent = 0);

signals:

public slots:
    void saveFile(QString path,QString data);
    QStringList getFileList(QString path,QString type);
    void copyFile(QString from,QString to);

    void b64e(QString path,QString alphabet);
    void b64d(QString path,QString alphabet);

    void p32(QString path,QString password,QString file);

};

#endif // FILESTREAM_H
