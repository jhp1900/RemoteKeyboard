import QtQuick 2.7

Rectangle {
    id: root;
    width: 400; height: 150;
    color: "lightblue";
    z: 100;
    radius: 5;
    visible: false;

    TextEdit {
        id: urlEdit
        width: 250;
        verticalAlignment: Text.AlignVCenter | Text.AlignHCenter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40
        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: "transparent"
            border.width: 1
        }
    }

    Item {
        id: btnAnchor;
        height: 40;
        anchors.bottom: root.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: root.horizontalCenter
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
        anchors.top: root.top
        anchors.right: root.right
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
        target: root;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }
    PropertyAnimation {
        id: animSmall;
        target: root;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
    }
}