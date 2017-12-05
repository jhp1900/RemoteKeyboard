import QtQuick 2.7
import QtQuick.Layouts 1.1

Rectangle {
    id: deskRoot;
    width: 480; height: 120;
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
            drag.target: deskRoot;
        }
    }

    GridLayout {
        columns: 1;
        rows: 4;
        anchors.fill: parent;
        rowSpacing: 5;

        Rectangle {
            color: "yellow";
            radius: 5;
            Layout.row: 1;
            Layout.column: 1;
        }
        Rectangle {
            color: "yellow";
            radius: 5;
            Layout.row: 1;
            Layout.column: 2;
        }
    }

//    Item {
//        id: btnAnchor;
//        height: 60;
//        anchors.verticalCenter: deskRoot.verticalCenter;
//        anchors.horizontalCenter: deskRoot.horizontalCenter;
//    }
//    Rectangle {
//        id: beginBtn;
//        height: 60;
//        color: "yellow";
//        anchors.verticalCenter: deskRoot.verticalCenter;
//        anchors.left: deskRoot.left;
//        anchors.leftMargin: 40;
//        radius: 5;
//        Text {
//            anchors.centerIn: parent;
//            text: qsTr("Ok");
//        }
//        MouseArea {
//            anchors.fill: parent;
//            onClicked: {
//                onClicked: hide();
//                emit: clickStart(urlEdit.text);
//            }
//        }
//    }
//    Rectangle {
//        height: 60;
//        color: "yellow";
//        anchors.verticalCenter: deskRoot.verticalCenter;
//        anchors.left: beginBtn.right;
//        anchors.leftMargin: 10;
//        anchors.right: deskRoot.right;
//        anchors.rightMargin: 40;
//        radius: 5;
//        Text {
//            anchors.centerIn: parent;
//            text: qsTr("Cancel");
//        }
//        MouseArea {
//            anchors.fill: parent;
//            onClicked: hide();
//        }
//    }

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
