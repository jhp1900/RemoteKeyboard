import QtQuick 2.7

Rectangle {
    id: bkUrlRoot;
    width: 480; height: 200;
    color: "lightblue";
    z: 100;
    radius: 5;
    visible: false;

    signal clickStart(string url);

    Rectangle {
        anchors.fill: parent;
        color: parent.color;
        radius: parent.radius;
        MouseArea {
            anchors.fill: parent;
            onPressed: {
                mouse.accepted = true;
            }
            drag.target: bkUrlRoot;
        }
    }

    TextEdit {
        id: urlEdit
        width: 400;
        verticalAlignment: Text.AlignVCenter | Text.AlignHCenter;
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.topMargin: 60;
        font.pixelSize: 18;
        text: "rtsp://18.18.8.197:554/123";
        Rectangle {
            anchors.fill: parent
            anchors.margins: -15
            color: "transparent"
            border.width: 1
        }
    }

    Item {
        id: btnAnchor;
        height: 60;
        anchors.bottom: bkUrlRoot.bottom;
        anchors.bottomMargin: 15;
        anchors.horizontalCenter: bkUrlRoot.horizontalCenter;
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
                onClicked: hide();
                emit: clickStart(urlEdit.text);
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
        anchors.top: bkUrlRoot.top;
        anchors.right: bkUrlRoot.right;
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
        target: bkUrlRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }
    PropertyAnimation {
        id: animSmall;
        target: bkUrlRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
    }
}
