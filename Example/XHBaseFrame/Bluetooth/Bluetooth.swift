//
//  Bluetooth.swift
//  ProjectApp
//
//  Created by jack on 2021/1/11.
//

import Foundation
import CoreBluetooth

class Bluetooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate  {
    var centralMgr: CBCentralManager!
    var curPeripheral: CBPeripheral?
    var writeCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
        var backgroundMode: Bool = false
        if let infoDic = Bundle.main.infoDictionary {
            let tempModes = infoDic["UIBackgroundModes"]
            if let modes = tempModes as? Array<String> {
                if modes.contains("bluetooth-central") {
                    backgroundMode = true
                }
            }
        }
        if backgroundMode {
            let options: [String : Any] = [
                CBCentralManagerOptionShowPowerAlertKey: true, // 初始化时若此时蓝牙系统为关闭状态，是否向用户显示警告对话框
                CBCentralManagerOptionRestoreIdentifierKey: "MWellnessBluetoothRestore" // 中心管理器的唯一标识符，系统根据这个标识识别特定的中心管理器，为了继续执行应用程序，标识符必须保持不变，才能还原中心管理类
            ]
            self.centralMgr = CBCentralManager(delegate: self, queue: nil, options: options)
        } else {
            self.centralMgr = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.centralMgr = central
        switch central.state {
        case .poweredOn:
            DLOG(message: "蓝牙打开")
            // 蓝牙已经打开，可以开始扫描蓝牙设备
            self.scanBluetooth()
            break;
        case .poweredOff:
            DLOG(message: "蓝牙关闭")
            // 这里检测到蓝牙关闭，一般会弹框提醒用户开启蓝牙
            break
        default:
         
           break
        }

    }
    
    
    /// 开始扫描蓝牙
    /// - Returns:
    func scanBluetooth() -> Void {
        var options: [String: Any] = [String: Any]()
        options[CBCentralManagerScanOptionAllowDuplicatesKey] = NSNumber(value: false)
        var services: [CBUUID]? // 这里可以通过筛选蓝牙的广播service来筛选扫描蓝牙
        self.centralMgr.scanForPeripherals(withServices: services, options: options)
        // TODO 扫描时，一般需要开个定时器来处理扫描超时业务,自行添加
    }
    
    /// 实时扫描到蓝牙时回调
    /// - Parameters:
    ///   - central:备
    ///   - peripheral: 扫描到的蓝牙设备
    ///   - advertisementData: 广播内容
    ///   - RSSI: 蓝牙信号强度，大部分为负数，负数值越大表示信号越强
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            // 实时扫描到蓝牙后，一般有两种常用业务
            // 1.弹框列出扫描的的蓝牙让用户选择连接哪个蓝牙
            // 2.业务已经约定好蓝牙名的匹配方式，扫描到后直接连接
            
            if name.lowercased().starts(with: "SHww-") {
                // 先停止扫描，再连接
                central.stopScan()
                self.curPeripheral = peripheral
                self.centralMgr.connect(peripheral, options: nil)
            }
        }
        
        // 获取对方蓝牙广播中的厂家数据
        if let manData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            
        }
        // 获取对方蓝牙广播中的蓝牙名，从peripheral.name获取的蓝牙名可能是手机缓存中的名称，从广播中获取的是实时的名称
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
        }
        
        if let txPowerLevel = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber {
            
        }
        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            
        }
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [String : Any] {
            
        }
       // 其他的还有CBAdvertisementDataOverflowServiceUUIDsKey,CBAdvertisementDataIsConnectable,CBAdvertisementDataSolicitedServiceUUIDsKey
        
    }
   
    
    /// 蓝牙连接失败
    /// - Parameters:
    ///   - central:
    ///   - peripheral:
    ///   - error:
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {

    }
    
    
    /// 蓝牙断开连接
    /// - Parameters:
    ///   - central:
    ///   - peripheral:
    ///   - error:
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
      
    }
    
    
    /// 蓝牙连接成功
    /// - Parameters:
    ///   - central:
    ///   - peripheral:
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 连接成功后，先设置蓝牙代理，再查找蓝牙对应的service
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    // MARK: - CBPeripheralDelegate
    
    /// 找到对方蓝牙service
    /// - Parameters:
    ///   - peripheral:
    ///   - error:
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // 找到对方蓝牙服务后,筛选service再查找服务对应的Characteristic，service的UUID双方先约定要，这里以FFE0开头的就是要找的服务，实际情况根据自己业务自行处理
        if let services = peripheral.services, let per = self.curPeripheral {
            for service in services {
                if service.uuid.uuidString.starts(with: "FFE0") {
                    per.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    
    /// 找到对方蓝牙的Characteristic
    /// - Parameters:
    ///   - peripheral:
    ///   - service:
    ///   - error:
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // 找到读、写Characteristic，读、写Characteristic的UUID双方先约定要，这里以FFE0开头的就是要找的服务，以FFE1开头的就是要找的可读Characteristic，以FFE2开头的就是要找的可写Characteristic，实际情况根据自己业务自行处理
        if let services = peripheral.services {
            for service in services {
                let serviceUUID = service.uuid.uuidString
                if serviceUUID.uppercased().contains("FFE0") {
                    if let characteristics = service.characteristics {
                        for characteristic in characteristics {
                            let characteristicUUID = characteristic.uuid.uuidString
                            if characteristicUUID.uppercased().contains("FFE1") { // 找到读Characteristic，设置为可通知
                                peripheral.setNotifyValue(true, for: characteristic)
                            } else if characteristicUUID.uppercased().contains("FFE2") { // 找到写Characteristic，临时保存为变量
                                self.writeCharacteristic = characteristic
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// 收到对方蓝牙发送的数据时回调
    /// - Parameters:
    ///   - peripheral:
    ///   - characteristic:
    ///   - error:
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
       
    }
    
    
    /// 发送数据成功时回调
    /// - Parameters:
    ///   - peripheral:
    ///   - characteristic:
    ///   - error:
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
       
    }
    
    
    /// 给对方蓝牙发送数据
    /// - Parameter data:
    /// - Returns:
    func sendData(data: [UInt8]) -> Void {
        if let per = self.curPeripheral, let ch = self.writeCharacteristic {
            let sendData: Data = Data(data)
            let properties: CBCharacteristicProperties = ch.properties
            if properties == CBCharacteristicProperties.writeWithoutResponse {
                per.writeValue(sendData, for: ch, type: CBCharacteristicWriteType.withoutResponse)
            } else {
               per.writeValue(sendData, for: ch, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
}
