import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.XmlListModel 2.0
import FileStream 1.0

ApplicationWindow {


    FileStream{
        id:fs
    }

    property string currentFilePath:"";

    function saveFile(path)
    {
        var fileData='<?xml version="1.0" encoding="utf-8"?>\r\n';
        fileData+='<SafetyDataFactory>\r\n';

        fileData+="<from>"+main.from+"</from>\r\n"
        fileData+="<to>"+main.to+"</to>\r\n"
        fileData+="<filterFile>"+main.filterFile+"</filterFile>\r\n";

        var actionList= main.actionList;
        for(var i=0;i<actionList.count;i++)
        {
            var action=actionList.get(i);

            fileData+="<action>\r\n"

            fileData+="<name>"+action.name+"</name>\r\n";
            fileData+="<type>"+action.type+"</type>\r\n";
            fileData+="<fileType>"+action.fileType+"</fileType>\r\n";

            switch(action.type)
            {
            case "b64e":
            case "b64d":
                if(action.alphabet)
                {
                    fileData+="<alphabet>"+action.alphabet+"</alphabet>\r\n";
                }

                break;
            case "p32e":
            case "p32d":
                if(action.password)
                {
                    fileData+="<password>"+action.password+"</password>\r\n";
                }

                if(action.startPos)
                {
                    fileData+="<startPos>"+action.startPos+"</startPos>\r\n";
                }

                if(action.density)
                {
                    fileData+="<density>"+action.density+"</density>\r\n";
                }

                if(action.file)
                {
                    fileData+="<file>"+action.file+"</file>\r\n";
                }

                break;
            case "zipe":
            case "zipd":

                break;
            case "command":
                if(action.command)
                {
                    fileData+="<command>"+action.command+"</command>\r\n";
                }
                if(action.filterFile)
                {
                    fileData+="<filterFile>"+action.filterFile+"</filterFile>\r\n";

                }

                break;
            }

            fileData+="</action>\r\n"
        }

        fileData+='</SafetyDataFactory>';

        fs.saveFile(path,fileData)

    }



    XmlListModel {
        id: xmlModel
        query: "/SafetyDataFactory/action"

        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "type"; query: "type/string()" }
        XmlRole { name: "fileType"; query: "fileType/string()" }
        XmlRole { name: "alphabet"; query: "alphabet/string()" }
        XmlRole { name: "password"; query: "password/string()" }
        XmlRole { name: "file"; query: "file/string()" }
        XmlRole { name: "startPos"; query: "startPos/string()" }
        XmlRole { name: "density"; query: "density/string()" }
        XmlRole { name: "command"; query: "command/string()" }
        XmlRole { name: "filterFile"; query: "filterFile/string()" }

        onStatusChanged: {
            var actionList= main.actionList;
            actionList.clear();

            for(var i=0;i<xmlModel.count;i++)
            {
                var action=xmlModel.get(i);
                actionList.append(action);
            }
        }

    }


    XmlListModel {
        id: fromToModel
        query: "/SafetyDataFactory"

        XmlRole { name: "from"; query: "from/string()" }
        XmlRole { name: "to"; query: "to/string()" }
        XmlRole { name: "filterFile"; query: "filterFile/string()" }

        onStatusChanged: {

            if(fromToModel.count==0)
                return;

            main.setFromTo(fromToModel.get(0).from,fromToModel.get(0).to);
            main.setFilterFile(fromToModel.get(0).filterFile);
        }

    }


    function openFile(path)
    {
        xmlModel.source="";
        xmlModel.source=path;
        fromToModel.source="";
        fromToModel.source=path;

        currentFilePath=path;
    }


    function run(from,to,filterFile,list)
    {

        //第0步 删除所有文件
        fs.deleteFile(to);

        //第一步 复制文件

        var fileList= fs.getFileList(from,"");

        //对文件列表进行过滤
        var filterList= filterFile.split("\n");
        console.log(filterList.length);
        for(var i=0;i<filterList.length;i++){
            var reg=new RegExp(filterList[i]);
            for(var j=0;j<fileList.length;j++)
            {
                if(reg.test(fileList[j]))
                {
                   fileList.splice(j,1,0);
                   j--;
                }
            }
        }
        console.log(fileList.length)
        for(var k=0;k<fileList.length;k++)
        {
            var fileFrom="file://"+fileList[k];
            var fileTo=to +fileFrom.substr(from.length);

            fs.copyFile(fileFrom,fileTo);

            console.log("copy",fileFrom,fileTo);
            main.log.append("\r\n"+"copy "+fileFrom+" "+fileTo);
        }


        //遍历所有Action 进行处理
        for(var i=0;i<list.count;i++)
        {
            var action= list.get(i);
            fileList= fs.getFileList(to,action.fileType);

            for(k=0;k<fileList.length;k++)
            {
                var path="file://"+fileList[k];

                console.log(action.type,"process",path);
                main.log.append("\r\n"+action.type+" process "+path);

                switch(action.type){
                case "b64e":
                    fs.b64e(path,action.alphabet);
                    break;
                case "b64d":
                    fs.b64d(path,action.alphabet);
                    break;
                case "p32e":
                case "p32d":
                    fs.p32(path,action.password,action.file,action.startPos,action.density);
                    break;
                case "command":

                    var isRun=true;

                    if(action.filterFile!=""&&action.filterFile!=null){
                        var fList=action.filterFile.split("\n");
                        for(var f=0;f<=filterList.length;f++)
                        {
                            var regEx=new RegExp(fList[f]);
                            if(regEx.test(path))
                            {
                                isRun=false;
                                break;
                            }
                        }
                    }
                    path=path.substr(7,path.length-7);
                    if(isRun){
                        var command=action.command.replace(/\$path/g,path);
                        fs.system(command);
                    }

                    break;
                }

            }

        }

    }


    function close()
    {
        currentFilePath="";
        main.setFromTo("","");
        main.actionList.clear();
    }

    title: qsTr("Safety Data Factory")
    width: 800
    height: 600
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                shortcut: "Ctrl+O"
                onTriggered: fileDialog.show(qsTr("Open safety data factory file (*.sdf)"),function(path){

                    openFile(path);
                    console.log(path);

                });

            }
            MenuItem {
                text: qsTr("&Save")
                shortcut: "Ctrl+S"
                onTriggered:if(currentFilePath==""){
                                saveFileDialog.show("Save safety data factory file",function(path){
                                    currentFilePath=path;
                                    saveFile(currentFilePath);
                                })
                            }else{
                                saveFile(currentFilePath);
                            }
            }
            MenuItem {
                text: qsTr("&Close")
                shortcut: "Ctrl+C"
                onTriggered: close()
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    MainForm {
        id:main
        width: 800
        height: 600
        anchors.fill: parent

        onRunClickd: {
            run(main.from,main.to,main.filterFile,main.actionList);
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"

        function show(caption,callback) {
            fileDialog.onAccepted.connect(function cb(){
                if(callback!=null)
                    callback(fileDialog.fileUrl);
                console.log("You chose: " + fileDialog.fileUrls)
                fileDialog.onAccepted.disconnect(cb);
            })
            fileDialog.open();
        }

    }

    FileDialog {
        id: saveFileDialog
        title: "Please choose a file"
        selectExisting: false
        nameFilters: "*.xml"
        function show(caption,callback) {
            saveFileDialog.onAccepted.connect(function cb(){
                if(callback!=null)
                    callback(saveFileDialog.fileUrl);
                console.log("You chose: " + saveFileDialog.fileUrls)
                saveFileDialog.onAccepted.disconnect(cb);
            })
            saveFileDialog.open();
        }
    }

}
