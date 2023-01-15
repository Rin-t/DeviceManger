//
//  AddNewDeviceViewModel.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/14.
//

import Foundation
import RxSwift
import RxRelay

protocol AddNewDeviceViewModelInput {
    var deviceName: BehaviorRelay<String> { get }
    var accountName: BehaviorRelay<String> { get }
    var deviceColor: BehaviorRelay<String> { get }
    var version: BehaviorRelay<String> { get }
    var holder: BehaviorRelay<String> { get }
    var tappedButton: PublishRelay<DeviceDataEntity> { get }
}

protocol AddNewDeviceViewModelOutput {
    var isEnabledButton: Observable<Bool> { get }
    var alertMessage: Observable<String> { get }
    var dismissView: Observable<Void> { get }
}

protocol AddNewDeviceViewModelType {
    var input: AddNewDeviceViewModelInput { get }
    var output: AddNewDeviceViewModelOutput { get }
}


final class AddNewDeviceViewModel: AddNewDeviceViewModelInput, AddNewDeviceViewModelOutput {

    // input
    let deviceName = BehaviorRelay<String>(value: "")
    let accountName = BehaviorRelay<String>(value: "")
    let deviceColor = BehaviorRelay<String>(value: "")
    let version = BehaviorRelay<String>(value: "")
    let holder = BehaviorRelay<String>(value: "")
    let tappedButton = PublishRelay<DeviceDataEntity>()

    // output
    var alertMessage: Observable<String>  {
        return alertMessageRelay.asObservable()
    }
    var isEnabledButton: Observable<Bool> {
        return isEnabledButtonRelay.asObservable()
    }
    var dismissView: Observable<Void> {
        return dismissViewRelay.asObservable()
    }

    // properties
    private let useCase: DeviceDataUseCaseProtocol
    private let isEnabledButtonRelay = BehaviorRelay<Bool>(value: false)
    private let alertMessageRelay = PublishRelay<String>()
    private let dismissViewRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    init(useCase: DeviceDataUseCaseProtocol) {
        self.useCase = useCase

        Observable.combineLatest(deviceName, accountName, deviceColor, version, holder)
            .map { deviceName, accountName, deviceColor, version, holder in
                !deviceName.isEmpty
                && !accountName.isEmpty
                && !deviceColor.isEmpty
                && !version.isEmpty
                && !holder.isEmpty
            }
            .bind(to: isEnabledButtonRelay)
            .disposed(by: disposeBag)

        tappedButton
            .subscribe { [weak self] deviceData in
                do {
                    try self?.useCase.loadDeviceData()
                    try self?.useCase.addDeviceData(data: deviceData)
                    self?.dismissViewRelay.accept(())
                } catch {
                    self?.alertMessageRelay.accept("データの保存に追加に失敗しました")
                }
            }
            .disposed(by: disposeBag)
    }
}

extension AddNewDeviceViewModel: AddNewDeviceViewModelType {

    var input: AddNewDeviceViewModelInput { return self }
    var output: AddNewDeviceViewModelOutput { return self }
}
