import QtQuick 2.7
import QtQuick.Layouts 1.1

Rectangle {
    id: deskRoot;
    width: 480; height: 120;
    color: "lightblue";
    z: 100;
    radius: 5;
    visible: false;

    //property string ctrAction: "CH1";

    signal sendAction(string action);

    Rectangle {
        anchors.fill: parent;
        color: parent.color;
        radius: parent.radius;
        MouseArea {
            anchors.fill: parent;
            onPressed: {
                mouse.accepted = true;
            }
            drag.target: deskRoot;
        }
    }

    RowLayout {
        anchors.fill: parent;
        spacing: 10;

        Rectangle {
            Layout.fillWidth: true;
        }

        Rectangle {
            id: beginBtn
            color: "yellow";
            Layout.fillWidth: true;
            Layout.preferredWidth: 120;
            Layout.preferredHeight: 60;
            radius: 5;
            Text {
                anchors.centerIn: parent;
                text: qsTr("开始录制")
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    emit: sendAction("BeginRecode");
                }
            }
        }
        Rectangle {
            id: stopBtn;
            color: "yellow";
            Layout.fillWidth: true;
            Layout.preferredWidth: 120;
            Layout.preferredHeight: 60;
            radius: 5;
            Text {
                anchors.centerIn: parent;
                text: qsTr("结束录制")
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    emit: sendAction("StopRecode");
                }
            }
        }
        Rectangle {
            id: autoBtn;
            color: "yellow";
            Layout.fillWidth: true;
            Layout.preferredWidth: 120;
            Layout.preferredHeight: 60;
            radius: 5;
            Text {
                anchors.centerIn: parent;
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
            color: "yellow";
            Layout.fillWidth: true;
            Layout.preferredWidth: 120;
            Layout.preferredHeight: 60;
            radius: 5;
            Text {
                anchors.centerIn: parent;
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
            text: "X";
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: hide();
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
