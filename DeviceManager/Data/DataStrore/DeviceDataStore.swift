//
//  DeviceDataStore.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/07.
//

import Foundation


protocol DeviceStoreProtocol {
    func updateData(data: [DeviceDataEntity]) throws
    func loadDate() throws -> [DeviceDataEntity]
}

final class DeviceDataStore: DeviceStoreProtocol {

    enum OSType {
        case iOS
        case android

        var key: String {
            switch self {
            case .iOS: return "iOSDeviceData"
            case .android: return "AndroidDeviceData"
            }
        }
    }

    private let deviceDataKey: String
    private let userDefault = UserDefaults.standard
    private let type: OSType

    init(type: OSType) {
        self.type = type
        deviceDataKey = type.key
    }

    func updateData(data: [DeviceDataEntity]) throws {
        try userDefault.set(struct: data, key: deviceDataKey)
    }

    func loadDate() throws -> [DeviceDataEntity] {
        let data: [DeviceDataEntity] = try userDefault.structData(key: deviceDataKey)
        return data
    }
}


