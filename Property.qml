import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

Item {
    id: item1
    width: 550
    height: 400




    Rectangle {
        id: listBackgorund
        color: "#ffffff"
        radius: 5
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.top: listView.top
        anchors.right: listView.right
        anchors.bottom: listView.bottom
        anchors.left: listView.left
        anchors.topMargin: 0
    }

    ListView {
        id: listView
        width: 209
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        clip: true
        delegate: Item {
            x: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            height: 40
            Column {
                Text {
                    text: name
                    font.bold: true
                    font.pixelSize: 15
                }
                Text {
                    text: typeText
                }

            }
            MouseArea {
                anchors.fill: parent
                onClicked: listView.currentIndex = index
            }
        }
        highlight: Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            color: "#ffff00";
            radius: 5
        }


        model: ListModel {
            id:actionList
        }


        onCurrentIndexChanged: {
            if(listView.currentIndex==-1){
                propertyBox.source="";
                return;
            }
            var action= actionList.get(listView.currentIndex);
            switch(action.type)
            {
            case "b64e":
            case "b64d":
                propertyBox.source="Base64Property.qml";
                propertyBox.item.actionData=action;

                break;
            case "p32e":
            case "p32d":
                propertyBox.source="Password32Property.qml";
                propertyBox.item.actionData=action;
                break;
            case "zipe":
            case "zipd":
                propertyBox.source="";
                break;
            }
        }
    }

    /*Connections {
            target: propertyBox.item
            onActionDataChanged: {
                if(actionData==null)
                    return;

                console.log(actionData.name);
            }
    }*/

    Dialog{
        id: addActionDialog
        width: 400
        height: 200

        title: "Please choose a Action"
        standardButtons: StandardButton.Yes|StandardButton.Cancel

        onYes: {
            onAccepted();
        }

        onAccepted: {

            var name= box.actionName.text
            var type=box.actionType.model.get(box.actionType.currentIndex).value
            var typeText=box.actionType.model.get(box.actionType.currentIndex).text
            var action={name:name,type:type,typeText:typeText};

            //actionList.push(action);
            actionList.append(action);
            listView.currentIndex=actionList.count-1;

        }

        AddAction{
            id:box
            anchors.fill: parent

        }
    }


    Button {
        id: add
        text: qsTr("➕")
        anchors.left: listView.left
        anchors.leftMargin: 0
        anchors.top: listView.bottom
        anchors.topMargin: 10
        opacity: 1
        onClicked: addActionDialog.open()
    }

    Button {
        id: remove
        text: qsTr("➖")
        anchors.left: add.right
        anchors.leftMargin: 3
        anchors.top: listView.bottom
        anchors.topMargin: 10
        onClicked: {
            if(listView.currentIndex==-1)
                return;
            actionList.remove(listView.currentIndex)
        }
    }

    Button {
        id: up
        x: 130
        text: qsTr("⬆️")
        anchors.top: listView.bottom
        anchors.topMargin: 10
        anchors.right: down.left
        anchors.rightMargin: 3
        onClicked: {
            if(listView.currentIndex==-1)
                return;

            if(listView.currentIndex-1<0)
                return;

            actionList.move(listView.currentIndex,listView.currentIndex-1,1);
        }

    }

    Button {
        id: down
        x: 171
        text: qsTr("⬇️")
        anchors.top: listView.bottom
        anchors.topMargin: 10
        anchors.right: listView.right
        anchors.rightMargin: 0
        onClicked: {
            if(listView.currentIndex==-1)
                return;

            if(listView.currentIndex+1>=actionList.count)
                return;

            actionList.move(listView.currentIndex,listView.currentIndex+1,1);
        }

    }

    SplitView {
        id: splitView
        orientation: Qt.Vertical
        anchors.left: listView.right
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 0

        Loader {
            id: propertyBox
            y: 10
            width: 310
            height: 233
        }

        TextArea {
            id: log
            x: 0
            width: 310
            height: 135
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            transformOrigin: Item.Center
        }
    }

    property ListModel actionList:actionList
    property TextArea log:log


}

