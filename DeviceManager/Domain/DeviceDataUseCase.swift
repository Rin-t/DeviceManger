//
//  DeviceDataUseCase.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/09.
//

import Foundation

protocol DeviceDataUseCaseProtocol {
    var deviceData: [DeviceDataEntity] { get }
    func loadDeviceData() throws
    func update(data: DeviceDataEntity, at index: Int) throws
    func addDeviceData(data: DeviceDataEntity) throws
    func remove(at index: Int) throws
}

final class DeviceDataUseCase: DeviceDataUseCaseProtocol {

    private let dataStore: DeviceStoreProtocol
    var deviceData: [DeviceDataEntity] = []

    init(dataStore: DeviceStoreProtocol) {
        self.dataStore = dataStore
    }

    func loadDeviceData() throws {
        do {
            deviceData = try dataStore.loadDate()
        } catch let error as UserDefaults.StructDataError {
            switch error {
            case .noDataError: break
            default: throw error
            }
        }
    }

    func addDeviceData(data: DeviceDataEntity) throws {
        deviceData.append(data)
        try dataStore.updateData(data: deviceData)
    }

    func update(data: DeviceDataEntity, at index: Int) throws {
        deviceData[index] = data
        try dataStore.updateData(data: deviceData)
    }

    func remove(at index: Int) throws {
        deviceData.remove(at: index)
        try dataStore.updateData(data: deviceData)
    }
}
