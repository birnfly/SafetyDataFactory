import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: item1
    width: 500
    height: 100

    TextField {
        id: actionName
        y: 23
        anchors.left: parent.left
        anchors.leftMargin: 60
        anchors.right: parent.right
        anchors.rightMargin: 10
        placeholderText: qsTr("Action name")
    }

    Label {
        id: label1
        x: 22
        y: 26
        text: qsTr("Name")
    }

    Label {
        id: label2
        x: 22
        y: 56
        text: qsTr("Type")
    }

    ComboBox {
        id: actionType
        y: 51
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 60
        activeFocusOnPress: false

        model: ListModel {
                id: cbItems
                ListElement { text: "Base64 Encode"; value: "b64e" }
                ListElement { text: "Base64 Decode"; value: "b64d" }
                ListElement { text: "Password32 Encode"; value: "p32e" }
                ListElement { text: "Password32 Decode"; value: "p32d" }
                ListElement { text: "Zip Encode"; value: "zipe" }
                ListElement { text: "Zip Decode"; value: "zipd" }
                ListElement { text: "Command"; value: "command" }

            }
    }

    readonly property TextField actionName:actionName
    readonly property ComboBox actionType:actionType

}

