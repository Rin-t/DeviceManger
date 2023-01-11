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
        return Observable.of(useCase.deviceData)
    }
    
    private let useCase: DeviceDataUseCaseProtocol

    init(useCase: DeviceDataUseCaseProtocol) {
        self.useCase = useCase
    }

    func viewWillAppear() {
        do {
            try useCase.loadDeviceData()
        } catch {
            print("エラー", error)
        }
    }
}


extension ManageiOSDeviceViewModel: ManageiOSDeviceViewModelType {

    var input: ManageiOSDeviceViewModelInput { return self }
    var output: ManageiOSDeviceViewModelOutput { return self }
}
