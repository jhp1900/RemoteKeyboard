import QtQuick 2.7

Rectangle {
    id: linkHomeRoot;
    width: 400; height: 150;
    color: "lightblue";
    z: 100;
    radius: 5;
    visible: false;

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
            width: 30;
            anchors.left: parent.left;
            anchors.leftMargin: 50;
            anchors.verticalCenter: parent.verticalCenter;
            text: "IP:"
        }
        TextEdit {
            id: ipEdit
            verticalAlignment: Text.AlignVCenter | Text.AlignHCenter
            anchors.left: ipText.right;
            anchors.right: portText.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: parent.verticalCenter;
            Rectangle {
                anchors.fill: parent
                anchors.margins: -8
                color: "transparent"
                border.width: 1
            }
        }

        Text {
            id: portText
            width: 40;
            anchors.right: portEdit.left;
            //anchors.leftMargin: 50;
            anchors.verticalCenter: parent.verticalCenter;
            text: "PORT:"
        }
        TextEdit {
            id: portEdit
            width: 40;
            verticalAlignment: Text.AlignVCenter | Text.AlignHCenter;
            anchors.right: parent.right;
            anchors.rightMargin: 50
            anchors.verticalCenter: parent.verticalCenter;

            Rectangle {
                anchors.fill: parent
                anchors.margins: -8
                color: "transparent"
                border.width: 1
            }
        }
    }

    Item {
        id: btnAnchor;
        height: 40;
        anchors.bottom: linkHomeRoot.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: linkHomeRoot.horizontalCenter
    }
    Rectangle {
        width: 80; height: 40;
        color: "yellow"
        anchors.top: btnAnchor.top
        anchors.right: btnAnchor.left
        anchors.rightMargin: 20
        radius: 5
        Text {
            anchors.centerIn: parent
            text: qsTr("Ok")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: console.log("Ok click")
        }
    }
    Rectangle {
        width: 80; height: 40;
        color: "yellow"
        anchors.top: btnAnchor.top
        anchors.left: btnAnchor.right
        anchors.leftMargin: 20
        radius: 5
        Text {
            anchors.centerIn: parent
            text: qsTr("Cancel")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: hide();
        }
    }

    Item {
        id: closeAnchor;
        anchors.top: linkHomeRoot.top
        anchors.right: linkHomeRoot.right
        anchors.topMargin: 20
        anchors.rightMargin: 20
    }
    Rectangle {
        width: 40; height: 40;
        anchors.bottom: closeAnchor.top
        anchors.left: closeAnchor.right
        color: "red"
        radius: 20
        Text {
            anchors.centerIn: parent
            text: "X"
        }
        MouseArea {
            anchors.fill: parent
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
