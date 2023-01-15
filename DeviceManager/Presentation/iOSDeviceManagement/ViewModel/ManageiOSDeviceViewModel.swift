//
//  ManageiOSDeviceViewModel.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/07.
//

import Foundation
import RxSwift
import RxRelay

protocol ManageiOSDeviceViewModelInput {
    func viewWillAppear()
}

protocol ManageiOSDeviceViewModelOutput {
    var deviceData: Observable<[DeviceDataEntity]> { get }
}

protocol ManageiOSDeviceViewModelType {
    var input: ManageiOSDeviceViewModelInput { get }
    var output: ManageiOSDeviceViewModelOutput { get }
}


final class ManageiOSDeviceViewModel: ManageiOSDeviceViewModelInput, ManageiOSDeviceViewModelOutput {

    var deviceData: Observable<[DeviceDataEntity]> {
        return deviceDataRelay.asObservable()
    }
    
    private let useCase: DeviceDataUseCaseProtocol
    private let deviceDataRelay = BehaviorRelay<[DeviceDataEntity]>(value: [])

    init(useCase: DeviceDataUseCaseProtocol) {
        self.useCase = useCase
    }

    func viewWillAppear() {
        do {
            try useCase.loadDeviceData()
            deviceDataRelay.accept(useCase.deviceData)
        } catch {
            print("エラー", error)
        }
    }
}


extension ManageiOSDeviceViewModel: ManageiOSDeviceViewModelType {

    var input: ManageiOSDeviceViewModelInput { return self }
    var output: ManageiOSDeviceViewModelOutput { return self }
}
