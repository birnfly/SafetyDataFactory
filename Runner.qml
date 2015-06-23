import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

Item{
    id: item1
    width: 550
    height: 100
    antialiasing: false

    TextField {
        id: fromPath
        y: 18
        height: 22
        text: qsTr("")
        anchors.left: parent.left
        anchors.leftMargin: 60
        anchors.right: borowsFrom.left
        anchors.rightMargin: 10
        placeholderText: qsTr("File or directory")
    }

    Button {
        id: borowsFrom
        x: 348
        y: 18
        text: qsTr("Browse")
        anchors.right: run.left
        anchors.rightMargin: 10
        onClicked: fileDialog.show("Please choose a Source Folder",function(path){

            fromPath.text=path;

        });
    }

    signal runClick();
    Button {
        id: run
        x: 440
        y: 18
        width: 102
        height: 64
        text: qsTr("Run")
        anchors.right: parent.right
        anchors.rightMargin: 10
        antialiasing: false
        smooth: true
        enabled: true
        transformOrigin: Item.Right

        onClicked: {
            runClick();
        }
    }

    TextField {
        id: toPath
        y: 58
        height: 22
        text: qsTr("")
        anchors.left: parent.left
        anchors.leftMargin: 60
        anchors.right: borowsTo.left
        anchors.rightMargin: 10
        placeholderText: qsTr("File or directory")
    }

    Button {
        id: borowsTo
        x: 348
        y: 56
        text: qsTr("Browse")
        anchors.right: run.left
        anchors.rightMargin: 10
        onClicked: fileDialog.show("Please choose a Source Folder",function(path){

            toPath.text=path;

        });

    }

    Text {
        id: text1
        y: 22
        text: qsTr("From")
        transformOrigin: Item.Right
        anchors.left: parent.left
        anchors.leftMargin: 20
        font.pixelSize: 12
    }

    Text {
        id: text2
        y: 61
        text: qsTr("To")
        anchors.left: parent.left
        anchors.leftMargin: 20
        transformOrigin: Item.Right
        font.pixelSize: 12
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        selectFolder : true
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            acceptedCallback(fileDialog.fileUrls);
            acceptedCallback.disconnect(acceptedCallbackFunc)
        }
        //onRejected: {
            //console.log("Canceled")
        //}
        //Component.onCompleted: visible = true


        signal acceptedCallback(string path)
        property var acceptedCallbackFunc
        function show(caption,callback) {
            fileDialog.title = caption;
            //fileDialog.acceptSelection()

            acceptedCallback.connect(callback);
            acceptedCallbackFunc=callback;
            fileDialog.open();
        }
    }


    property string from: fromPath.text
    property string to:toPath.text

    function setFromTo(from,to){
        fromPath.text=from;
        toPath.text=to;
    }
}

