import QtQuick 2.7

Rectangle {
    id: linkHomeRoot;
    width: 480; height: 200;
    color: "#55000000";
    border.color: "#55ffffff";
    border.width: 1;
    z: 200;
    radius: 5;
    visible: false;

    signal clickLinkHome(string ip, string port);

    Rectangle {
        anchors.fill: parent;
        color: "transparent";
        radius: parent.radius;
        MouseArea {
            anchors.fill: parent;
            onPressed: {
                mouse.accepted = true;
            }
            drag.target: linkHomeRoot;
        }
    }

    Text {
        id: ipHint;
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
        text: "连接主机";
    }

    Rectangle {
        id: editRect
        height: 60;
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: ipHint.bottom
        color: "transparent";
        radius: parent.radius;

        Text {
            id: ipText;
            width: 30;
            anchors.left: parent.left;
            anchors.leftMargin: 20;
            anchors.verticalCenter: parent.verticalCenter;
            color: "white";
            text: "IP:"
        }
        TextInput {
            id: ipEdit
            height: 46;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
            anchors.left: ipText.right;
            anchors.right: portText.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: 18;
            selectByMouse: true;
            color: "white";
            Rectangle {
                anchors.fill: parent;
                color: "#22ffffff";
                border.color: "#44ffffff";
                border.width: 1;
                radius: 5;
            }
        }

        Text {
            id: portText
            width: 46;
            anchors.right: portEdit.left;
            anchors.verticalCenter: parent.verticalCenter;
            color: "white";
            text: "PORT:";
        }
        TextInput {
            id: portEdit
            width: 80; height: 46;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
            anchors.right: parent.right;
            anchors.rightMargin: 20;
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: 18;
            selectByMouse: true;
            color: "white";
            Rectangle {
                anchors.fill: parent;
                color: "#22ffffff";
                border.color: "#44ffffff";
                border.width: 1;
                radius: 5;
            }
        }
    }

    Rectangle {
        id: ctrlPanel;
        color: "transparent";
        anchors.left: parent.left;
        anchors.top: editRect.bottom;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        Item {
            id: btnAnchor;
            height: 70;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
        Rectangle {
            width: 120; height: 70;
            anchors.top: btnAnchor.top;
            anchors.right: btnAnchor.left;
            anchors.rightMargin: 20;
            color: "#44014e60";
            border.color: "#44000000";
            border.width: 1;
            radius: 5;
            Text {
                anchors.centerIn: parent;
                font.pointSize: 18;
                font.bold: true;
                style: Text.Outline;
                styleColor: "#ffffff";
                text: qsTr("确定");
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    linkHome();
                    hide();
                }
            }
        }
        Rectangle {
            width: 120; height: 70;
            anchors.top: btnAnchor.top;
            anchors.left: btnAnchor.right;
            anchors.leftMargin: 20;
            color: "#44014e60";
            border.color: "#44000000";
            border.width: 1;
            radius: 5;
            Text {
                anchors.centerIn: parent;
                font.pointSize: 18;
                font.bold: true;
                style: Text.Outline;
                styleColor: "#ffffff";
                text: qsTr("取消");
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: hide();
            }
        }
    }

    Item {
        id: closeAnchor;
        anchors.top: linkHomeRoot.top;
        anchors.right: linkHomeRoot.right;
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

    Connections {
        target: win;
        onInitData: {
            ipEdit.text = ip;
            portEdit.text = port;
        }
    }

    function show() {
        visible = true;
        animBig.start();
    }

    function hide() {
        animSmall.start();
    }

    function linkHome() {
        emit: clickLinkHome(ipEdit.text, portEdit.text);
    }

    PropertyAnimation {
        id: animBig;
        target: linkHomeRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }
    PropertyAnimation {
        id: animSmall;
        target: linkHomeRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
    }
}
