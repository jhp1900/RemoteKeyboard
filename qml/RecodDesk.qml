import QtQuick 2.7
import QtQuick.Layouts 1.1

Rectangle {
    id: deskRoot;
    width: 305; height: 130;
    color: "transparent";
    z: 200;

    property int recodeState: -1;
    property int directMode: -1;
    property string dirAction: "BeginRecord";
    property string dirStr: "开始录制";

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
        id: dirBtn;
        height: 60;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        color: "#55000000";
        border.color: "#55ffffff";
        border.width: 1
        radius: 5;
        Text {
            id: dirText;
            anchors.centerIn: parent;
            font.pixelSize: 20;
            font.bold: true;
            style: Text.Outline;
            styleColor: "#ffffff";
            text: dirStr;
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                emit: sendAction(dirAction);
            }
        }
    }
    Rectangle {
        id: stopBtn;
        height: 60;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        color: "#55000000";
        border.color: "#55ffffff";
        border.width: 1
        radius: 5;
        Text {
            id: stopText;
            anchors.centerIn: parent;
            font.pixelSize: 20;
            font.bold: true;
            style: Text.Outline;
            styleColor: "#ffffff";
            text: qsTr("结束录制")
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                emit: sendAction("StopRecord");
            }
        }
    }

    onRecodeStateChanged: {
        if (recodeState === 0) {    // 停止态
            dirAction = "BeginRecord";
            dirStr = "开始录制";
            dirText.color = "black";
        } else if (recodeState === 1) {     // 录制态
            dirAction = "PauseRecord";
            dirStr = "暂停录制";
            dirText.color = "red";
        } else if (recodeState === 2) {     // 暂停态
            dirAction = "BeginRecord";
            dirStr = "继续录制";
            dirText.color = "red";
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
