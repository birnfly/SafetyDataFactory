#include "filestream.h"
#include <QtCore/QTextStream>

#include <QtCore/QFile>
#include <QtCore/QDir>
#include <QtCore/QUrl>
#include <QtCore/QIODevice>
#include <QtCore/QVector>

#include "Base64.h"
#include "Password32.h"
#include <fstream>

FileStream::FileStream(QObject *parent) : QObject(parent)
{

}


void FileStream::saveFile(QString path,QString data)
{
    if(path=="")
        return;

    QFile file(QUrl(path).toLocalFile());

    if (!file.open(QIODevice::WriteOnly|QIODevice::Text)) {
        qDebug("error");
        return;
    }
    QTextStream out(&file);
    out<<data.toUtf8()<<endl;
    out.flush();
    file.close();



}

void FileStream::getFileList(QString path,QString type,QStringList* list)
{
     if(path=="")
     {
         return;
     }

    QStringList typelist=type.split(",");


     QDir dir(path);

     dir.setFilter(QDir::Dirs | QDir::Files);
     dir.setSorting(QDir::Size | QDir::Reversed);

     QFileInfoList l = dir.entryInfoList();
     for (int i = 0; i < l.size(); ++i) {
         QFileInfo fileInfo = l.at(i);

         if(fileInfo.fileName()=="."||fileInfo.fileName()=="..")
             continue;

         if(fileInfo.isFile())
         {
            bool isOK=false;

            if(type.isNull()||type.isEmpty()||type=="")
            {
                isOK=true;
            }else for(int i=0;i<typelist.count();i++)
            {
                QString type=typelist[i];
                if(fileInfo.completeSuffix().compare(type,Qt::CaseInsensitive)==0){
                    isOK=true;
                    break;
                }
            }

            if(isOK)
            {
                list->push_back(fileInfo.filePath());
            }
         }else if(fileInfo.isDir()){
            getFileList(fileInfo.filePath(),type,list);
         }

     }

}

QStringList FileStream::getFileList(QString path,QString type)
{

    QStringList list;


    getFileList(QUrl(path).toLocalFile(),type,&list);

    return list;
}


void FileStream::copyFile(QString from,QString to)
{

    from=QUrl(from).toLocalFile();
    to=QUrl(to).toLocalFile();

    if (from == to){
            return;
    }
    if (!QFile::exists(from)){
        return;
    }
    QDir removeFile;
    bool exist = removeFile.exists(to);
    if (exist){
        removeFile.remove(to);
    }

    //create path
    QString s=QFileInfo(to).path();
    QDir::current().mkpath(QFileInfo(to).path());

    QFile::copy(from, to);
}

void FileStream::b64e(QString path,QString alphabet)
{
    path=QUrl(path).toLocalFile();

    Base64 b64;
    if(alphabet.isNull()==false &&alphabet.isEmpty()==false && alphabet!="")
    {
        b64.setAlphabet(alphabet.toStdString());
    }

    std::fstream file;
    file.open(path.toStdString().c_str(),std::ios_base::in|std::ios_base::out|std::ios::binary|std::ios::ate);
    int size=file.tellg(); //通过标志ate得到文件大小。
    char* buf=new char[size];
    file.seekg(0,std::ios::beg); //把读取位置重新写入文件开头。
    file.read(buf,size);
    file.close();
    file.clear();

    b64.encode((unsigned char*)buf,size);

    file.open(path.toStdString().c_str(),std::ios::binary|std::ios::in|std::ios::out|std::ios::trunc);
    file.seekg(0,std::ios::beg);
    file.write((char*)b64.getResultData(),b64.getResultSize());
    file.close();

    delete[] buf;
}

void FileStream::b64d(QString path,QString alphabet)
{
    path=QUrl(path).toLocalFile();

    Base64 b64;
    if(alphabet.isNull()==false &&alphabet.isEmpty()==false && alphabet!="")
    {
        b64.setAlphabet(alphabet.toStdString());
    }

    std::fstream file;
    file.open(path.toStdString().c_str(),std::ios_base::in|std::ios_base::out|std::ios::binary|std::ios::ate);
    int size=file.tellg(); //通过标志ate得到文件大小。
    char* buf=new char[size];
    file.seekg(0,std::ios::beg); //把读取位置重新写入文件开头。
    file.read(buf,size);
    file.close();
    file.clear();

    b64.decode((unsigned char*)buf,size);

    file.open(path.toStdString().c_str(),std::ios::binary|std::ios::in|std::ios::out|std::ios::trunc);
    file.seekg(0,std::ios::beg);
    file.write((char*)b64.getResultData(),b64.getResultSize());
    file.close();

    delete[] buf;
}

void FileStream::p32(QString path,QString password,QString filePassword)
{
    path=QUrl(path).toLocalFile();

    std::fstream file;
    file.open(path.toStdString().c_str(),std::ios_base::in|std::ios_base::out|std::ios::binary|std::ios::ate);
    int size=file.tellg(); //通过标志ate得到文件大小。
    char* buf=new char[size];
    file.seekg(0,std::ios::beg); //把读取位置重新写入文件开头。
    file.read(buf,size);
    file.close();
    file.clear();

    const char* pwd=password.toStdString().c_str();
    if(password.isEmpty() && filePassword.isEmpty()==false)
    {
        filePassword=QUrl(filePassword).toLocalFile();

        file.open(filePassword.toStdString().c_str(),std::ios_base::in|std::ios_base::out|std::ios::binary|std::ios::ate);
        int size=file.tellg(); //通过标志ate得到文件大小。
        pwd=new char[size];
        file.seekg(0,std::ios::beg); //把读取位置重新写入文件开头。
        file.read(buf,size);
        file.close();
        file.clear();
    }

    Password32 pwd32;
    pwd32.exe(buf,size,buf,(char *)pwd);

    file.open(path.toStdString().c_str(),std::ios::binary|std::ios::in|std::ios::out|std::ios::trunc);
    file.seekg(0,std::ios::beg);
    file.write(buf,size);
    file.close();

    delete[] buf;
}
