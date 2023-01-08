//
//  DeviceDataStore.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/07.
//

import Foundation


protocol DeviceStoreProtocol {
    func updateData(data: DeviceDataEntity) throws
    func loadDate() throws -> DeviceDataEntity
}

final class DeviceDataStore: DeviceStoreProtocol {

    private let deviceDataKey = "deviceData"
    private let userDefault = UserDefaults.standard

    func updateData(data: DeviceDataEntity) throws {
        try userDefault.set(struct: data, key: deviceDataKey)
    }

    func loadDate() throws -> DeviceDataEntity {
        let data: DeviceDataEntity = try userDefault.structData(key: deviceDataKey)
        return data
    }
}


