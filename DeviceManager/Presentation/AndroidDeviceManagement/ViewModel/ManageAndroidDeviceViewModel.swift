//
//  ManageAndroidDeviceViewModel.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/16.
//

import Foundation
import RxSwift
import RxRelay

protocol ManageAndroidDeviceViewModelInput {
    func viewWillAppear()
}

protocol ManageAndroidDeviceViewModelOutput {
    var deviceData: Observable<[DeviceDataEntity]> { get }
}

protocol ManageAndroidDeviceViewModelType {
    var input: ManageAndroidDeviceViewModelInput { get }
    var output: ManageAndroidDeviceViewModelOutput { get }
}


final class ManageAndroidDeviceViewModel: ManageAndroidDeviceViewModelInput, ManageAndroidDeviceViewModelOutput {

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


extension ManageAndroidDeviceViewModel: ManageAndroidDeviceViewModelType {

    var input: ManageAndroidDeviceViewModelInput { return self }
    var output: ManageAndroidDeviceViewModelOutput { return self }
}
