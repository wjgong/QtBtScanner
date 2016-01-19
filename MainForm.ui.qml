import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

Item {
    id: item1
    width: 1280
    height: 720
    property alias scanningIndicator: scanningIndicator
    property alias buttonScan: buttonScan
    property alias deviceListModel: deviceListModel
    property alias devicesView: devicesView

    BusyIndicator {
        id: scanningIndicator
        z: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }

    RowLayout {
        id: mainLayout
        width: 1260
        height: 720
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 20

        ColumnLayout {
            id: panelLayout
            y: 190
            width: 180
            clip: false
            opacity: 1
            z: 0
            Layout.fillHeight: true
            Layout.fillWidth: false
            spacing: 15
            Layout.columnSpan: 1

            Button {
                id: buttonScan
                x: 0
                width: 100
                Layout.fillHeight: false
                Layout.fillWidth: true
                style: ButtonStyle {
                    label: Text {
                        font.bold: true
                        text: qsTr("SCAN")
                        width: paintedWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            CheckBox {
                id: checkBoxVisible
                x: 0
                width: 227
                Layout.minimumWidth: 223
                Layout.fillHeight: false
                Layout.fillWidth: false
                checked: true
                style: CheckBoxStyle {
                    label: Text {
                        font.bold: true
                        color: "white"
                        text: qsTr("Visible for others")
                    }
                }
            }
        }

        GridView {
            id: devicesView
            x: 260
            y: 0
            width: 140
            height: 700
            boundsBehavior: Flickable.DragOverBounds
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            cacheBuffer: 320
            Layout.columnSpan: 0
            Layout.rowSpan: 0
            layoutDirection: Qt.LeftToRight
            flickableDirection: Flickable.HorizontalFlick
            flow: GridView.FlowTopToBottom
            keyNavigationWraps: true
            contentHeight: 70
            Layout.fillWidth: true
            Layout.fillHeight: true

            delegate: Item {
                x: 5
                height: 50
                Column {
                    y: 10
                    Rectangle {
                        id: deviceRect
                        y: 0
                        width: 240
                        height: 100
                        color: "#183693"
                        clip: true
                        anchors.horizontalCenter: parent.horizontalCenter

                        MouseArea {
                            id: deviceMouseArea
                            anchors.fill: parent
                            onClicked: devicesView.currentIndex = index
                        }

                        Text {
                            id: deviceName
                            y: 5
                            text: name
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            clip: false
                            enabled: false
                            color: "#ffffff"
                            font.bold: true
                        }

                        Image {
                            id: deviceIcon
                            y: 25
                            smooth: false
                            enabled: false
                            fillMode: Image.PreserveAspectFit
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                            source: iconSource
                        }

                        Text {
                            id: deviceStatus
                            text: "<i>" + pairingStatus + "</i>"
                            enabled: false
                            anchors.left: deviceIcon.right
                            anchors.leftMargin: 5
                            anchors.verticalCenter: deviceIcon.verticalCenter
                            color: "#ffffff"
                        }
                    }

                    spacing: 20
                }
            }

            cellWidth: 210
            cellHeight: 120

            model: ListModel {
                id: deviceListModel
            }
        }
    }
}
