//
//  EditDeviceDataViewController.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/15.
//

import UIKit
import RxSwift
import RxCocoa

final class EditDeviceDataViewController: UIViewController {

    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet private weak var deviceTextField: UITextField!
    @IBOutlet private weak var colorTextField: UITextField!
    @IBOutlet private weak var accountTextField: UITextField!
    @IBOutlet private weak var holderTextField: UITextField!
    @IBOutlet private weak var versionTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 8
        }
    }
    private let deleteButton = UIButton()

    private let viewModel: EditDeviceDataViewModelType
    private let disposeBag = DisposeBag()

    init(type: DeviceDataStore.OSType, selectedIndex: IndexPath) {
        self.viewModel = EditDeviceDataViewModel(
            useCase: DeviceDataUseCase(
                dataStore: DeviceDataStore(type: .iOS)
            ), selectedRow: selectedIndex.row
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItem()
        setupView()
        setupOutput()
        viewModel.input.viewDidLoad()
        setupInput()
    }

    private func setupView() {
        tabBarController?.tabBar.isHidden = true
    }

    private func setupNavigationBarItem() {
        let image = UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        deleteButton.setImage(image, for: .normal)
        deleteButton.imageView?.contentMode = .scaleAspectFill
        deleteButton.contentHorizontalAlignment = .fill
        deleteButton.contentVerticalAlignment = .fill
        deleteButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let deleteTabBarItem = UIBarButtonItem(customView: deleteButton)
        navigationItem.rightBarButtonItems = [deleteTabBarItem]
    }

    private func setupInput() {
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showDestructiveAlert(message: "このデータを削除しますか？") {
                    self?.viewModel.input.tappedDeleteButton.accept(())
                }
            })
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .map { [weak self] _ in
                return DeviceDataEntity(device: self?.deviceTextField.text ?? "",
                                        holder: self?.holderTextField.text ?? "",
                                        version: self?.versionTextField.text ?? "",
                                        color: self?.colorTextField.text ?? "",
                                        accountName: self?.accountTextField.text ?? "")
            }
            .bind(to: viewModel.input.tappedSaveButton)
            .disposed(by: disposeBag)

        deviceTextField.rx.text.orEmpty
            .bind(to: viewModel.input.deviceName)
            .disposed(by: disposeBag)

        colorTextField.rx.text.orEmpty
            .bind(to: viewModel.input.deviceColor)
            .disposed(by: disposeBag)

        accountTextField.rx.text.orEmpty
            .bind(to: viewModel.input.accountName)
            .disposed(by: disposeBag)

        holderTextField.rx.text.orEmpty
            .bind(to: viewModel.input.holder)
            .disposed(by: disposeBag)

        deviceTextField.rx.text.orEmpty
            .bind(to: viewModel.input.version)
            .disposed(by: disposeBag)

    }

    private func setupOutput() {
        viewModel.output.deviceData
            .subscribe(onNext: { [weak self] deviceData in
                print("deviceData")
                self?.deviceTextField.text = deviceData.device
                self?.colorTextField.text = deviceData.color
                self?.accountTextField.text = deviceData.accountName
                self?.holderTextField.text = deviceData.holder
                self?.versionTextField.text = deviceData.version
            })
            .disposed(by: disposeBag)

        viewModel.output.isEnabledButton
            .subscribe(onNext: { [weak self] isEnabled in
                print(isEnabled)
                self?.saveButton.isEnabled = isEnabled
                self?.saveButton.backgroundColor = isEnabled ? .orange : .systemGray3
                self?.alertTextLabel.isHidden = isEnabled
            })
            .disposed(by: disposeBag)

        viewModel.output.dismissView
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message, completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            })
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

    private func showDestructiveAlert(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let destructive = UIAlertAction(title: "削除する", style: .destructive) { _ in
            completion?()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(destructive)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
