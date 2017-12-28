import QtQuick 2.7
//import QtQuick.Layouts 1.1

Rectangle {
    id: stateRoot;
    width: 120; height: 60;
    color: "#00000000";
    visible: false;

    property int recodeState: -1;
    property int directMode: -1;

    Rectangle {
        width: parent.width / 2;
        height: parent.height;
        anchors.left: parent.left;
        anchors.top: parent.top;
        color: "#55000000";
        border.color: "#55ffffff";
        border.width: 1;
        radius: 30;
        Text {
            id: rcdTxt;
            anchors.centerIn: parent;
            font.pixelSize: 24;
            font.bold: true;
            style: Text.Outline;
            styleColor: "#ffffff";
            text: "停止";
        }
//        MouseArea {
//            anchors.fill: parent;
//            onClicked: ;
//        }
    }

    Rectangle {
        width: parent.width / 2;
        height: parent.height;
        anchors.right: parent.right;
        anchors.top: parent.top;
        color: "#55000000";
        border.color: "#55ffffff";
        border.width: 1;
        radius: 30;
        Text {
            id: dirTxt;
            anchors.centerIn: parent;
            font.pixelSize: 24;
            font.bold: true;
            style: Text.Outline;
            styleColor: "#ffffff";
            text: "自动";
        }
//        MouseArea {
//            anchors.fill: parent;
//            onClicked: ;
//        }
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: ;
    }

    onRecodeStateChanged: {
        if (recodeState === 0) {    // 停止态
            rcdTxt.text = "停止";
            rcdTxt.color = "black";
        } else if (recodeState === 1) {     // 录制态
            rcdTxt.text = "录制";
            rcdTxt.color = "red";
        } else if (recodeState === 2) {     // 暂停态
            rcdTxt.text = "暂停";
            rcdTxt.color = "red";
        }
    }

    onDirectModeChanged: {
        if (directMode === 0) {
            dirTxt.text = "自动";
        } else if (directMode === 1) {
            dirTxt.text = "手动";
        }
    }

    PropertyAnimation {
        id: animBig;
        target: stateRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }

    function show() {
        stateRoot.visible = true;
        animBig.start();
    }
}
