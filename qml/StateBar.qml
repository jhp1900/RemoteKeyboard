import QtQuick 2.7
import QtQuick.Layouts 1.1

Rectangle {
    id: stateRoot;
    width: 120; height: 60;
    color: "#00000000";
    radius: 5;

    property int recodeState: -1;
    property int directMode: -1;

    Image {
        id: rcdImg;
        width: parent.width / 2;
        height: parent.height;
        anchors.left: parent.left;
        anchors.top: parent.top;
        source: "qrc:/res/begin.png";
    }

    Image {
        id: dirImg;
        width: parent.width / 2;
        height: parent.height;
        anchors.right: parent.right;
        anchors.top: parent.top;
        source: "qrc:/res/auto.png";
    }

    onRecodeStateChanged: {
        if (recodeState === 0) {    // 停止态
            rcdImg.source = "qrc:/res/stop.png";
        } else if (recodeState === 1) {     // 录制态
            rcdImg.source = "qrc:/res/begin.png";
        } else if (recodeState === 2) {     // 暂停态
            rcdImg.source = "qrc:/res/pause.png";
        }
    }

    onDirectModeChanged: {
        if (directMode === 0) {
            dirImg.source = "qrc:/res/auto.png";
        } else if (directMode === 1) {
            dirImg.source = "qrc:/res/manual.png";
        }
    }
}
