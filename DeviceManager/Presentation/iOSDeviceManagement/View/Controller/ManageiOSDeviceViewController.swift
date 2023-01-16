//
//  ManageiOSDeviceViewController.swift
//  DeviceManager
//
//  Created by Rin on 2022/12/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ManageiOSDeviceViewController: UIViewController {

    typealias Cell = DeviceManagementCollectionViewCell

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.layer.cornerRadius = 10
            collectionView.register(Cell.nib(), forCellWithReuseIdentifier: Cell.identifier)
            collectionView.showsVerticalScrollIndicator = false
        }
    }

    @IBOutlet private weak var addDeviceButton: UIButton! {
        didSet {
            addDeviceButton.layer.cornerRadius = addDeviceButton.frame.width / 2
        }
    }
    private let disposeBag = DisposeBag()
    private let viewModel = ManageiOSDeviceViewModel(
        useCase: DeviceDataUseCase(
            dataStore: DeviceDataStore(type: .iOS)
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionViewLayout()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear()
        tabBarController?.tabBar.isHidden = false
    }

    private func setupBindings() {
        viewModel.output.deviceData
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
                cell.configure(data: element)
                return cell
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
                let vc = EditDeviceDataViewController(type: .iOS, selectedIndex: indexPath)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        addDeviceButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let vc = AddNewDeviceDataViewController(type: .iOS)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupCollectionViewLayout() {
        let cellWidth = collectionView.frame.width - 32
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 80, right: 16)
        layout.minimumLineSpacing = 32
        collectionView.collectionViewLayout = layout
    }

    private func setupView() {
        view.backgroundColor = .systemGray5
        navigationItem.title = "iOSデバイス管理"
    }
}


