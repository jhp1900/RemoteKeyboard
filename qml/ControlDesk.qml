import QtQuick 2.7
import QtQuick.Layouts 1.1

Rectangle {
    id: deskRoot;
    width: 560; height: 200;
    color: "#55000000";
    border.color: "#55ffffff";
    border.width: 1;
    z: 200;
    radius: 5;
    visible: false;

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

    Text {
        id: conHint;
        height: 50;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.leftMargin: 20;
        verticalAlignment: Text.AlignVCenter;
        font.pixelSize: 24;
        font.bold: true;
        style: Text.Outline;
        styleColor: "#ffffff";
        text: "控制台"
    }

    Rectangle {
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.top: conHint.bottom;
        color: "transparent"

        RowLayout {
            width: 460;
            height: 120;
            anchors.centerIn: parent;
            spacing: 10;
            Rectangle {
                Layout.fillWidth: true;
            }

            Rectangle {
                id: dirBtn;
                Layout.fillWidth: true;
                Layout.preferredWidth: 120;
                Layout.preferredHeight: 80;
                color: "#44014e60";
                border.color: "#44000000";
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
                Layout.fillWidth: true;
                Layout.preferredWidth: 120;
                Layout.preferredHeight: 80;
                color: "#44014e60";
                border.color: "#44000000";
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
            Rectangle {
                id: autoBtn;
                Layout.fillWidth: true;
                Layout.preferredWidth: 120;
                Layout.preferredHeight: 80;
                color: "#44014e60";
                border.color: "#44000000";
                border.width: 1
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
            Rectangle {
                id: manualBtn;
                Layout.fillWidth: true;
                Layout.preferredWidth: 120;
                Layout.preferredHeight: 80;
                color: "#44014e60";
                border.color: "#44000000";
                border.width: 1
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
                Layout.fillWidth: true;
            }
        }
        }

    Item {
        id: closeAnchor;
        anchors.top: deskRoot.top;
        anchors.right: deskRoot.right;
        anchors.topMargin: 20;
        anchors.rightMargin: 20;
    }
    Rectangle {
        width: 40; height: 40;
        anchors.bottom: closeAnchor.top;
        anchors.left: closeAnchor.right;
        color: "red";
        radius: 20;
        Text {
            anchors.centerIn: parent;
            font.pointSize: 20;
            text: "X";
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: hide();
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
