//
//  AddNewDeviceViewController.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/11.
//

import UIKit
import RxSwift
import RxCocoa


final class AddNewDeviceViewController: UIViewController {

    @IBOutlet private weak var deviceNameTextField: UITextField!
    @IBOutlet private weak var deviceColorTextField: UITextField!
    @IBOutlet private weak var deviceAccountTextField: UITextField!
    @IBOutlet private weak var holderTextField: UITextField!
    @IBOutlet private weak var deviceVersionTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 8
        }
    }

    private let viewModel: AddNewDeviceViewModelType
    private let disposeBag = DisposeBag()

    init(type: DeviceDataStore.OSType) {
        viewModel = AddNewDeviceViewModel(useCase: DeviceDataUseCase(dataStore: DeviceDataStore(type: type)))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputs()
        setupOutput()
    }

    private func setupOutput() {

        viewModel.output.dismissView
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.output.alertMessage
            .subscribe(onNext: { [weak self] message in
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupInputs() {
        deviceNameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.deviceName)
            .disposed(by: disposeBag)

        deviceColorTextField.rx.text.orEmpty
            .bind(to: viewModel.input.deviceColor)
            .disposed(by: disposeBag)

        deviceAccountTextField.rx.text.orEmpty
            .bind(to: viewModel.input.accountName)
            .disposed(by: disposeBag)

        holderTextField.rx.text.orEmpty
            .bind(to: viewModel.input.holder)
            .disposed(by: disposeBag)

        deviceVersionTextField.rx.text.orEmpty
            .bind(to: viewModel.input.version)
            .disposed(by: disposeBag)
    }

}

