import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    width: 800
    height: 600

    //property alias button2: button2
    //property alias button1: button1

    property ListModel actionList:property.actionList
    property TextArea log:property.log

    property string from:runner.from
    property string to:runner.to

    property string filterFile:runner.filterFile

    function setFromTo(from,to)
    {
         runner.setFromTo(from,to);
    }

    function setFilterFile(filter)
    {
         runner.setFilterFile(filter);
    }
    RowLayout {
        anchors.centerIn: parent




    }


    GroupBox {
        id: groupBox1
        anchors.top: groupBox2.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        title: qsTr("Property")

        Property {
            id: property
            anchors.fill: parent
        }
    }

    signal runClickd();
    GroupBox {
        id: groupBox2
        height: 180
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        title: qsTr("Runner")

        Runner {
            id: runner
            anchors.fill: parent

            onRunClick:runClickd()
        }
    }

}
