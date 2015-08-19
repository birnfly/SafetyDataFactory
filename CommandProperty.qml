import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2


Rectangle {
    id: rectangle1
    width: 550
    height: 400
    anchors.fill: parent


    RowLayout {
        id: rowLayout1
        y: 8
        height: 101
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        Label {
            id: label1
            text: qsTr("Command")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        TextArea {
            id: command
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 100
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.fill: parent

            text:actionData.command?actionData.command:""
            onTextChanged: actionData.command=command.text

        }



    }

    RowLayout {
        id: rowLayout2
        x: 8
        y: 122
        height: 88
        anchors.right: parent.right
        Label {
            id: label2
            text: qsTr("Filter File")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        TextArea {
            id: filterFile
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 100
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 0

            text:actionData.filterFile?actionData.filterFile:""
            onTextChanged: actionData.filterFile=filterFile.text

        }
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    RowLayout {
        y: 216
        height: 44
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        Label {
            text: qsTr("File type")
            anchors.left: parent.left
            anchors.leftMargin: 10
        }


        TextField {
            id: fileType
            anchors.right: parent.right
            anchors.left: parent.left
            placeholderText: qsTr("jpg,png,zip,csv,xml,plist")
            anchors.leftMargin: 70
            anchors.rightMargin: 10
            text:actionData.fileType?actionData.fileType:""
            onTextChanged: actionData.fileType=fileType.text
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



    property var actionData;
    //signal onActionDataChanged(var actionData);



}

