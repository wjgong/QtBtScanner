import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtBluetooth 5.3
import tieto.project.scanner 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    color: "#000000"
    title: qsTr("Tieto BT Scanner")

    menuBar: MenuBar {
        Menu {
            title: qsTr("Change Your View")
            MenuItem {
                text: qsTr("Metro")
                onTriggered: console.log("Metro View Selected");
            }
            MenuItem {
                text: qsTr("3D")
                onTriggered: console.log("3D veiw Selected");
            }
        }
    }

    MainForm {
        id: mainForm1
        anchors.fill: parent

        buttonScan.onClicked: {
            if (BTScanner.startDeviceDiscovery()) {
                deviceListModel.clear()
                scanningIndicator.running = true
            }
        }

        scanningIndicator {
            RotationAnimator on rotation {
                running: mainForm1.scanningIndicator.running
                loops: Animation.Infinite
                duration: 1000
                from: 0; to : 360
            }
        }

        devicesView.onCurrentIndexChanged: {
            if (!mainForm1.scanningIndicator.running) {
                var element = deviceListModel.get(devicesView.currentIndex)
                console.log("the current device " + element.address)
                BTScanner.startDevicePairing(element.address)
                mainForm1.deviceListModel.setProperty(devicesView.currentIndex,
                                                      "pairingStatus",
                                                      qsTr("Pairing"))
            }
        }

        function appendDevice(name, address, type, status) {
            var element = {
                'name': name === null ? address : name,
                'address': address,
                'iconSource': type + ".svg",
                'pairingStatus': status === "Unpaired" ? qsTr("Unpaired") : qsTr("Paired")
            }
            deviceListModel.append(element)
        }

        function updateDevice(address, status) {
            console.log("update device " + address + " status")
            for (var i = 0; i < deviceListModel.count; i ++) {
                if (deviceListModel.get(i).address === address) {
                    deviceListModel.setProperty(i, "pairingStatus",
                                                status === "Unpaired" ? qsTr("Unpaired") : qsTr("Paired"))
                    return
                }
            }
            console.log("did not find the device to update")
        }

        Connections {
            target: BTScanner
            onCompleted: {
                mainForm1.devicesView.currentIndex = -1
                mainForm1.scanningIndicator.running = false
            }
        }
        Connections {
            target: BTScanner
            onDeviceDiscovered: mainForm1.appendDevice(name, address, type, status)
        }
        Connections {
            target: BTScanner
            onPairingFinished: mainForm1.updateDevice(address, status)
        }
    }
}
