//
//  EditDeviceDataViewModel.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/15.
//

import Foundation
import RxSwift
import RxRelay

protocol EditDeviceDataViewModelInput {
    var deviceName: BehaviorRelay<String> { get }
    var accountName: BehaviorRelay<String> { get }
    var deviceColor: BehaviorRelay<String> { get }
    var version: BehaviorRelay<String> { get }
    var holder: BehaviorRelay<String> { get }
    var tappedSaveButton: PublishRelay<(DeviceDataEntity)> { get }
    var tappedDeleteButton: PublishRelay<Void> { get }
    func viewDidLoad()
}

protocol EditDeviceDataViewModelOutput {
    var isEnabledButton: Observable<Bool> { get }
    var deviceData: Observable<DeviceDataEntity> { get }
    var alertMessage: Observable<String> { get }
    var dismissView: Observable<String> { get }
}

protocol EditDeviceDataViewModelType: EditDeviceDataViewModelInput, EditDeviceDataViewModelOutput {
    var input: EditDeviceDataViewModelInput { get }
    var output: EditDeviceDataViewModelOutput { get }
}

final class EditDeviceDataViewModel {

    // input
    let deviceName = BehaviorRelay<String>(value: "")
    let accountName = BehaviorRelay<String>(value: "")
    let deviceColor = BehaviorRelay<String>(value: "")
    let version = BehaviorRelay<String>(value: "")
    let holder = BehaviorRelay<String>(value: "")
    let tappedSaveButton = PublishRelay<(DeviceDataEntity)>()
    let tappedDeleteButton = PublishRelay<Void>()

    // output
    var alertMessage: Observable<String>  {
        return alertMessageRelay.asObservable()
    }
    var isEnabledButton: Observable<Bool> {
        return isEnabledButtonRelay.asObservable()
    }
    var dismissView: Observable<String> {
        return dismissViewRelay.asObservable()
    }
    var deviceData: Observable<DeviceDataEntity> {
        return deviceDataRelay.asObservable()
    }

    private let isEnabledButtonRelay = PublishRelay<Bool>()
    private let alertMessageRelay = PublishRelay<String>()
    private let dismissViewRelay = PublishRelay<String>()
    private let deviceDataRelay = PublishRelay<DeviceDataEntity>()
    private let disposeBag = DisposeBag()
    private let useCase: DeviceDataUseCaseProtocol
    private let selectedRow: Int

    init(useCase: DeviceDataUseCaseProtocol, selectedRow: Int) {
        self.selectedRow = selectedRow
        self.useCase = useCase

        Observable.combineLatest(deviceName, accountName, deviceColor, version, holder)
            .map { deviceName, accountName, deviceColor, version, holder in
                return !deviceName.isEmpty
                && !accountName.isEmpty
                && !deviceColor.isEmpty
                && !version.isEmpty
                && !holder.isEmpty
            }
            .bind(to: isEnabledButtonRelay)
            .disposed(by: disposeBag)

        tappedSaveButton
            .subscribe(onNext: { [weak self] data in
                do {
                    try self?.useCase.update(data: data, at: selectedRow)
                    self?.dismissViewRelay.accept("データを変更しました")
                } catch {
                    self?.alertMessageRelay.accept("データの変更に失敗しました")
                }
            })
            .disposed(by: disposeBag)

        tappedDeleteButton
            .subscribe(onNext: { [weak self] _ in
                do {
                    try self?.useCase.remove(at: selectedRow)
                    self?.dismissViewRelay.accept("データの削除しました")
                } catch {
                    self?.alertMessageRelay.accept("データの削除に失敗しました")
                }
            })
            .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        do {
            try useCase.loadDeviceData()
            deviceDataRelay.accept(useCase.deviceData[selectedRow])
        } catch {
            print("error")
        }
    }
}

extension EditDeviceDataViewModel: EditDeviceDataViewModelType {

    var input: EditDeviceDataViewModelInput { return self }
    var output: EditDeviceDataViewModelOutput { return self }
}
