import QtQuick 2.7
import QtQuick.Layouts 1.1

Rectangle {
    id: deskRoot;
    width: 450; height: 60;
    color: "transparent";
    z: 200;

    property int directMode: -1;

    signal sendAction(string action);

    Rectangle {
        anchors.fill: parent;
        color: "transparent";
        radius: parent.radius;
        MouseArea {
            anchors.fill: parent;
            onPressed: {
                mouse.accepted = true;
            }
            drag.target: deskRoot;
        }
    }

    Rectangle {
        id: manualBtn;
        width: 220;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        color: "#55000000";
        border.color: "#55ffffff";
        border.width: 1;
        radius: 5;
        Text {
            id: manualText;
            anchors.centerIn: parent;
            font.pixelSize: 20;
            font.bold: true;
            style: Text.Outline;
            styleColor: "#ffffff";
            text: qsTr("手动导播")
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                emit: sendAction("ManualDirector");
            }
        }
    }

    Rectangle {
        id: autoBtn;
        width: 220;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        color: "#55000000";
        border.color: "#55ffffff";
        border.width: 1;
        radius: 5;
        Text {
            id: autoText;
            anchors.centerIn: parent;
            font.pixelSize: 20;
            font.bold: true;
            style: Text.Outline;
            styleColor: "#ffffff";
            text: qsTr("自动导播")
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                emit: sendAction("AutoDirector");
            }
        }
    }

    onDirectModeChanged: {
        if (directMode === 0) {
            autoText.color = "red";
            manualText.color = "black";
        } else if (directMode === 1) {
            manualText.color = "red";
            autoText.color = "black";
        }
    }

    function show() {
        visible = true;
        animBig.start();
    }

    function hide() {
        animSmall.start();
    }

    PropertyAnimation {
        id: animBig;
        target: deskRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }
    PropertyAnimation {
        id: animSmall;
        target: deskRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
    }
}
