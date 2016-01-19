#include "scanner.h"

Scanner::Scanner(QObject *parent) : QObject(parent)
{
    // Create a discovery agent and connect to its signals
    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    connect(m_discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this,SLOT(deviceDiscovered(QBluetoothDeviceInfo)));
    connect(m_discoveryAgent, SIGNAL(finished()),
            this, SLOT(discoveryCompleted()));

    m_localDevice = new QBluetoothLocalDevice(this);
    m_scanPending = false;
    connect(m_localDevice, SIGNAL(hostModeStateChanged(QBluetoothLocalDevice::HostMode)),
            this, SLOT(startPendingScan(QBluetoothLocalDevice::HostMode)));
    connect(m_localDevice, SIGNAL(pairingFinished(QBluetoothAddress,QBluetoothLocalDevice::Pairing)),
            this, SLOT(pairingDone(QBluetoothAddress,QBluetoothLocalDevice::Pairing)));
}

Scanner::~Scanner()
{
    delete m_localDevice;
    delete m_discoveryAgent;
}

bool Scanner::startDeviceDiscovery()
{
    if (m_localDevice->hostMode() == QBluetoothLocalDevice::HostPoweredOff) {
        m_localDevice->powerOn();
        m_scanPending = true;
    } else {
        if (!m_discoveryAgent->isActive()) {
            // Start a discovery
            m_discoveryAgent->start();
        } else {
            return false;
        }
    }

    return true;
}

void Scanner::startPendingScan(QBluetoothLocalDevice::HostMode state)
{
    if (state != QBluetoothLocalDevice::HostPoweredOff && m_scanPending) {
        m_scanPending = false;
        m_discoveryAgent->start();
    }
}

void Scanner::deviceDiscovered(const QBluetoothDeviceInfo &device)
{
    qDebug() << "Found new device:" << device.name() << '(' << device.address().toString() << ')';

    QBluetoothLocalDevice::Pairing pairing = m_localDevice->pairingStatus(device.address());
    QString status;
    switch (pairing) {
    case QBluetoothLocalDevice::Paired:
        status = "Paired";
        break;

    case QBluetoothLocalDevice::Unpaired:
        status = "Unpaired";
        break;

    case QBluetoothLocalDevice::AuthorizedPaired:
        status = "AuthorizedPaired";
        break;
    }

    emit deviceDiscovered(device.name(),
                          device.address().toString(),
                          deviceType(device.majorDeviceClass(),device.minorDeviceClass()),
                          status);
}

QString Scanner::deviceType(const QBluetoothDeviceInfo::MajorDeviceClass major, const quint8 minor)
{
    QString deviceType;

    qDebug("BT major device class: %d", major);
    switch(major) {
    case QBluetoothDeviceInfo::PhoneDevice:
        deviceType = "phone";
        break;

    case QBluetoothDeviceInfo::AudioVideoDevice:
        if (QBluetoothDeviceInfo::WearableHeadsetDevice == minor ||
                QBluetoothDeviceInfo::HandsFreeDevice == minor ||
                QBluetoothDeviceInfo::Headphones == minor)
            deviceType = "headset";
        break;

    case QBluetoothDeviceInfo::WearableDevice:
        deviceType = "watch";
        break;

    case QBluetoothDeviceInfo::ComputerDevice:
        deviceType = "computer";
        break;

    default:
        deviceType = "bluetooth";
    }

    return deviceType;
}

void Scanner::discoveryCompleted()
{
    emit completed();
}

void Scanner::startDevicePairing(QString address)
{
    m_localDevice->requestPairing(QBluetoothAddress(address), QBluetoothLocalDevice::Paired);
}

void Scanner::pairingDone(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing pairing)
{
    emit pairingFinished(address.toString(),
                         pairing == QBluetoothLocalDevice::Unpaired ? "Unpaired" : "Paired");
}
