//
//  DeviceDataEntity.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/07.
//

import Foundation

struct DeviceDataEntity: Codable {
    let id: String
    let device: String
    let holder: String
    let version: String
    let color: String
    let accountName: String
}
