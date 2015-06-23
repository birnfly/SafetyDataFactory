import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1


Rectangle {
    id: rectangle1
    width: 550
    height: 400
    anchors.fill: parent


    RowLayout {
        id: rowLayout1
        y: 8
        height: 44
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        Label {
            id: label1
            text: qsTr("Alphabet")
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Button {
            id: reset
            text: qsTr("Rest")
            anchors.right: parent.right
            anchors.rightMargin: 10
            onClicked: actionData.alphabet=null
        }

        TextField {
            id: alphabet
            anchors.right: reset.left
            anchors.rightMargin: 10
            anchors.left: label1.right
            anchors.leftMargin: 10
            placeholderText: qsTr("alphabet")
            text:actionData.alphabet!=null?actionData.alphabet:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

            onTextChanged: actionData.alphabet=alphabet.text
        }



    }
    RowLayout {
        y: 60
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
            placeholderText: qsTr("input jpg,png,zip,csv,xml,plist")
            text:actionData.fileType?actionData.fileType:""
            anchors.leftMargin: 70
            anchors.rightMargin: 10

            onTextChanged: actionData.fileType=fileType.text
        }



    }
    property var actionData;
    //signal onActionDataChanged(var actionData);
}

