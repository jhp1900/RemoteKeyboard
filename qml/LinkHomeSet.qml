import QtQuick 2.7

Rectangle {
    id: linkHomeRoot;
    width: 480; height: 200;
    color: "lightblue";
    z: 100;
    radius: 5;
    visible: false;

    signal clickLinkHome(string ip, string port);

    Rectangle {
        anchors.fill: parent;
        color: parent.color;
        radius: parent.radius;
        MouseArea {
            anchors.fill: parent;
            onPressed: {
                mouse.accepted = true;
            }
            drag.target: linkHomeRoot;
        }
    }

    Rectangle {
        id: editRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: btnAnchor.top
        color: parent.color;
        radius: parent.radius;

        Text {
            id: ipText;
            width: 50;
            anchors.left: parent.left;
            anchors.leftMargin: 30;
            anchors.verticalCenter: parent.verticalCenter;
            text: "IP:"
        }
        TextEdit {
            id: ipEdit
            verticalAlignment: Text.AlignVCenter | Text.AlignHCenter
            anchors.left: ipText.right;
            anchors.right: portText.left;
            anchors.rightMargin: 40;
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: 18;
            text: "18.18.8.22";
            Rectangle {
                anchors.fill: parent
                anchors.margins: -14
                color: "transparent"
                border.width: 1
            }
        }

        Text {
            id: portText
            width: 60;
            anchors.right: portEdit.left;
            anchors.verticalCenter: parent.verticalCenter;
            text: "PORT:"
        }
        TextEdit {
            id: portEdit
            width: 60;
            verticalAlignment: Text.AlignVCenter | Text.AlignHCenter;
            anchors.right: parent.right;
            anchors.rightMargin: 50;
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: 18;
            text: "12307";
            Rectangle {
                anchors.fill: parent
                anchors.margins: -14
                color: "transparent"
                border.width: 1
            }
        }
    }

    Item {
        id: btnAnchor;
        height: 60;
        anchors.bottom: linkHomeRoot.bottom;
        anchors.bottomMargin: 15;
        anchors.horizontalCenter: linkHomeRoot.horizontalCenter;
    }
    Rectangle {
        width: 120; height: 60;
        color: "yellow";
        anchors.top: btnAnchor.top;
        anchors.right: btnAnchor.left;
        anchors.rightMargin: 20;
        radius: 5;
        Text {
            anchors.centerIn: parent;
            text: qsTr("Ok");
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                emit: clickLinkHome(ipEdit.text, portEdit.text);
                hide();
            }
        }
    }
    Rectangle {
        width: 120; height: 60;
        color: "yellow";
        anchors.top: btnAnchor.top;
        anchors.left: btnAnchor.right;
        anchors.leftMargin: 20;
        radius: 5;
        Text {
            anchors.centerIn: parent;
            text: qsTr("Cancel");
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: hide();
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
