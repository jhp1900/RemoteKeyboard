import QtQuick 2.0

Rectangle {
    width: 150;
    height: 150;
    color: "#88000000"
    border.color: "#55ffffff";
    border.width: 1;
    radius: 75;

    signal clickMenuBtn(bool isFront);

    Flipable {
        id: flip;
        anchors.fill: parent;
        property bool flipped: false;

        front: Rectangle {
            anchors.fill: parent;
            color: "transparent";
            Text {
                anchors.centerIn: parent;
                font.pointSize: 30;
                font.bold: true;
                style: Text.Outline;
                styleColor: "#ffffff";
                text: "Init";
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    //dispatching.onQmlGetInitData();
                    emit: clickMenuBtn(true);
                    flip.flipped = true;
                }
            }
        }

        back: Rectangle {
            anchors.fill: parent;
            color: "transparent";
            Text {
                anchors.centerIn: parent;
                font.pointSize: 30;
                font.bold: true;
                style: Text.Outline;
                styleColor: "#ffffff";
                text: "菜单";
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    emit: clickMenuBtn(false);
                }
            }
        }

        transform: Rotation {
            id: rotation;
            origin.x: flip.width / 2;
            origin.y: flip.height / 2;
            axis.x: 0;
            axis.y: 1;
            axis.z: 0;
            angle: 0;
        }

        states: State {
            PropertyChanges {
                target: rotation;
                angle: 180;
            }
            when: flip.flipped;
        }

        transitions: Transition {
            NumberAnimation{
                target:rotation
                properties: "angle"
                duration:1000
            }
        }
    }
}
