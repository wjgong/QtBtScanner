#ifndef SCANNER_H
#define SCANNER_H

#include <QObject>
#include <QtBluetooth/QBluetoothDeviceDiscoveryAgent>
#include <QtBluetooth/QBluetoothLocalDevice>
#include <QBluetoothDeviceInfo>
#include <QString>
#include <QList>
#include <QDebug>

class Scanner : public QObject
{
    Q_OBJECT
public:
    explicit Scanner(QObject *parent = 0);
    ~Scanner();
    Q_INVOKABLE bool startDeviceDiscovery();
    Q_INVOKABLE void startDevicePairing(QString address);

private:
    QString deviceType(const QBluetoothDeviceInfo::MajorDeviceClass major,
                       const quint8 minor);

signals:
    void deviceDiscovered(const QString name, const QString address,
                          const QString type, const QString status);
    void completed();
    void pairingFinished(const QString address, const QString status);

private slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &device);
    void discoveryCompleted();
    void startPendingScan(QBluetoothLocalDevice::HostMode state);
    void pairingDone(const QBluetoothAddress &address,
                     QBluetoothLocalDevice::Pairing pairing);

private:
    QBluetoothDeviceDiscoveryAgent *m_discoveryAgent;
    QBluetoothLocalDevice *m_localDevice;
    bool m_scanPending;
};

#endif // SCANNER_H
