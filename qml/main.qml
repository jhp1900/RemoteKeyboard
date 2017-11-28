import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.2

Window {
    visible: true
    width: Screen.width;
    height: Screen.height;
    title: qsTr("RemoteKeyboard")
    flags: Qt.WindowSystemMenuHint | Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

    Rectangle {
        anchors.fill: parent;

        Image {
            id: img
            anchors.fill: parent
            source: "image://provider"
        }

        Connections {
            target: dispatching
            onCallQmlRefeshImg: {
                img.source = ""
                img.source = "image://provider"
            }
        }

        Rectangle {
            id: menuBtn;
            width: 80;
            height: 80;
            anchors.top: parent.top;
            anchors.topMargin: 10;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            color: "red"

            MouseArea {
                id:btnMenu;
                anchors.fill: parent;
                onClicked: {
                    if(menuCtrol.status === Loader.Null) {
                        menuCtrol.sourceComponent = comMenu;
                    } else if(menuCtrol.status === Loader.Ready) {
                        menuCtrol.sourceComponent = undefined
                    }
                }
            }
        }

        Loader {
            id:menuCtrol;
            anchors.left: menuBtn.left
            anchors.top: menuBtn.bottom
        }

        Component {
            id:comMenu;
            Rectangle {
                width: 80;
                height: 170;
                color: "#3c3c3c"

                Column {
                    anchors.centerIn: parent;
                    anchors.margins: 2;
                    spacing: 2;
                    Rectangle {
                        width: 76;
                        height: 40;
                        color: "#00718c"
                        border.color: Qt.lighter(color);
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("背景流")
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                dispatching.start();
                                menuCtrol.sourceComponent = undefined;
                            }
                        }
                    }
                    Rectangle {
                        width: 76;
                        height: 40;
                        color: "#00718c"
                        border.color: Qt.lighter(color);
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("连接主机")
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menuCtrol.sourceComponent = undefined;
                            }
                        }
                    }
                    Rectangle {
                        width: 76;
                        height: 40;
                        color: "#00718c"
                        border.color: Qt.lighter(color);
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("控制台")
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menuCtrol.sourceComponent = undefined;
                            }
                        }
                    }
                    Rectangle {
                        width: 76;
                        height: 40;
                        color: "#00718c"
                        border.color: Qt.lighter(color);
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("退出")
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Click 退出 Btn");
                                Qt.quit();
                            }
                        }
                    }
                }
            }
        }

//        Rectangle {
//            width: 100
//            height: 80
//            color: "green"

//            Drag.active: dragArea.drag.active
//            Drag.hotSpot.x: 10
//            Drag.hotSpot.y: 10

//            MouseArea {
//                id: dragArea
//                anchors.fill: parent
//                drag.target: parent
//                onClicked: {
//                    console.log("Drag On Click!")
//                }
//            }
//        }

    }


}
