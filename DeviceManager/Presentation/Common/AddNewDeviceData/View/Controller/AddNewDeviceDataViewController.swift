//
//  AddNewDeviceViewController.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/11.
//

import UIKit
import RxSwift
import RxCocoa


final class AddNewDeviceDataViewController: UIViewController {

    // outlets
    @IBOutlet private weak var deviceNameTextField: UITextField!
    @IBOutlet private weak var deviceColorTextField: UITextField!
    @IBOutlet private weak var deviceAccountTextField: UITextField!
    @IBOutlet private weak var holderTextField: UITextField!
    @IBOutlet private weak var deviceVersionTextField: UITextField!
    @IBOutlet private weak var alertTextLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 8
        }
    }

    // properties
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
        tabBarController?.tabBar.isHidden = true
    }

    private func setupOutput() {

        viewModel.output.dismissView
            .subscribe { [weak self] _ in
                self?.showAlert(message: "保存に成功しました", completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
            .disposed(by: disposeBag)

        viewModel.output.alertMessage
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.output.isEnabledButton
            .subscribe(onNext: { [weak self] isEnabled in
                self?.saveButton.isEnabled = isEnabled
                self?.saveButton.backgroundColor = isEnabled ? .orange : .systemGray3
                self?.alertTextLabel.isHidden = isEnabled
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

        saveButton.rx.tap
            .subscribe { [weak self] _ in
                let device = self?.deviceNameTextField.text ?? ""
                let color = self?.deviceColorTextField.text ?? ""
                let account = self?.deviceAccountTextField.text ?? ""
                let holder = self?.holderTextField.text ?? ""
                let version = self?.deviceVersionTextField.text ?? ""
                let data = DeviceDataEntity(device: device,
                                            holder: holder,
                                            version: version,
                                            color: color,
                                            accountName: account)
                self?.viewModel.input.tappedSaveButton.accept(data)
            }
            .disposed(by: disposeBag)
    }

    private func showAlert(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

