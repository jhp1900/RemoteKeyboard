import QtQuick 2.7
import QtQuick.Dialogs 1.2

Rectangle {
    id: bkRoot;
    width: 560; height: 200;
    color: "#55000000";
    border.color: "#55ffffff";
    border.width: 1;
    z: 200;
    radius: 5;
    visible: false;

    signal clickStart(string bkUrl, string bkImg, bool isImg);
//    signal getUrl();

    Rectangle {
        anchors.fill: parent;
        color: "transparent";
        radius: parent.radius;
        MouseArea {
            anchors.fill: parent;
            onPressed: {
                mouse.accepted = true;
            }
            drag.target: bkRoot;
        }
    }

    Rectangle {
        id: showPanel;
        height: 110;
        color: "transparent";
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: ctrlPanel.top;

        Flipable {
            id: flip;
            anchors.fill: parent;
            property bool flipped: false;

            front: Rectangle {
                anchors.fill: parent;
                color: "transparent";
                Text {
                    id: urlHint;
                    height: 50;
                    anchors.left: parent.left;
                    anchors.top: parent.top;
                    anchors.right: parent.right;
                    anchors.leftMargin: 20;
                    verticalAlignment: Text.AlignVCenter;
                    font.pixelSize: 24
                    font.bold: true;
                    style: Text.Outline;
                    styleColor: "#ffffff";
                    text: "背景流:"
                }
                Rectangle {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.bottom: parent.bottom;
                    anchors.top: urlHint.bottom;
                    color: "transparent"
                    TextInput {
                        id: urlEdit;
                        height: 46;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.left: parent.left;
                        anchors.right: parent.right;
                        anchors.leftMargin: 20;
                        anchors.rightMargin: 20;
                        font.pixelSize:16;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        selectByMouse: true;
                        Rectangle {
                            anchors.fill: parent
                            color: "#22ffffff";
                            border.color: "#44ffffff";
                            border.width: 1
                            radius: 5;
                        }
                    }
                }
            }

            back: Rectangle {
                anchors.fill: parent;
                color: "transparent";

                Text {
                    id: imgHint;
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
                    text: "背景图:"
                }
                Rectangle {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.bottom: parent.bottom;
                    anchors.top: imgHint.bottom;
                    color: "transparent";

                    TextInput {
                        id: imgPath;
                        height: 46;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.left: parent.left;
                        anchors.right: btnBkBrowse.left;
                        anchors.leftMargin: 20;
                        anchors.rightMargin: 4;
                        font.pixelSize: 16
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        selectByMouse: true;
                        readOnly: true;
                        Rectangle {
                            anchors.fill: parent
                            color: "#22ffffff";
                            border.color: "#44ffffff";
                            border.width: 1
                            radius: 5;
                        }
                    }
                    Rectangle {
                        id: btnBkBrowse;
                        width: 48; height: 48;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.right: parent.right;
                        anchors.rightMargin: 20;
                        color: "#44014e60";
                        border.color: "#44000000";
                        border.width: 1
                        radius: 5;
                        Text {
                            anchors.centerIn: parent;
                            style: Text.Outline;
                            styleColor: "#ffffff";
                            font.pixelSize: 18
                            text: "打开";
                        }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                fileDialog.open();
                            }
                        }
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
                    duration:500
                }
            }

            onFlippedChanged: {
                if (flipped) {
                    urlBtnTxt.color = "black";
                    imgBtnTxt.color = "red";
                } else {
                    urlBtnTxt.color = "red";
                    imgBtnTxt.color = "black";
                }
            }
        }
    }

    Rectangle {
        id: ctrlPanel;
        color: "transparent";
        anchors.left: parent.left;
        anchors.top: showPanel.bottom;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        Item {
            id: btnAnchor;
            height: 70;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
        Rectangle {
            id: btnOk;
            width: 120; height: 70;
            anchors.top: btnAnchor.top;
            anchors.right: btnAnchor.left;
            anchors.rightMargin: 10;
            color: "#44014e60";
            border.color: "#44000000";
            border.width: 1
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
                    onClicked: hide();
                    if (flip.flipped)
                        emit: clickStart(urlEdit.text, imgPath.text, true);
                    else
                        emit: clickStart(urlEdit.text, imgPath.text, false)
                }
            }
        }
        Rectangle {
            id: btnCancel;
            width: 120; height: 70;
            anchors.top: btnAnchor.top;
            anchors.left: btnAnchor.right;
            anchors.leftMargin: 10;
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
        Rectangle {
            width: 70; height: 70;
            anchors.top: btnAnchor.top;
            anchors.right: btnOk.left;
            anchors.rightMargin: 20;
            color: "#44014e60";
            border.color: "#44000000";
            border.width: 1
            radius: 5;
            Text {
                id: urlBtnTxt;
                anchors.centerIn: parent;
                font.pointSize: 16;
                font.bold: true;
                color: "red";
                style: Text.Outline;
                styleColor: "#ffffff";
                text: qsTr("< URL");
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: flip.flipped = false;
            }
        }
        Rectangle {
            width: 70; height: 70;
            anchors.top: btnAnchor.top;
            anchors.left: btnCancel.right;
            anchors.leftMargin: 20;
            color: "#44014e60";
            border.color: "#44000000";
            border.width: 1
            radius: 5;
            Text {
                id: imgBtnTxt;
                anchors.centerIn: parent;
                font.pointSize: 16;
                font.bold: true;
                style: Text.Outline;
                styleColor: "#ffffff";
                text: qsTr("IMG >");
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: flip.flipped = true;
            }
        }
    }

    Item {
        id: closeAnchor;
        anchors.top: bkRoot.top;
        anchors.right: bkRoot.right;
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

    FileDialog {
        id: fileDialog;
        title: "Background Image";
        nameFilters: ["IMG(*.png *.jpg *.jpeg)"];
        onAccepted: {
            imgPath.text = fileDialog.fileUrl;
        }
        onRejected: {
            console.log("Canceled");
        }
    }

//    Component.onCompleted: {
//        //emit: getUrl();
//        console.log("Component.onCompleted - - - - -- - - - - - - - ");
//    }

    Connections {
        target: win;
        onInitData: {
            urlEdit.text = bkUrl;
            imgPath.text = bkImg;
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
        target: bkRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }
    PropertyAnimation {
        id: animSmall;
        target: bkRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
    }
}
