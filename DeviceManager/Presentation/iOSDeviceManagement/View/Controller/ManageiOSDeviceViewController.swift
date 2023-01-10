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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        navigationItem.title = "iOSデバイス管理"

        setupCollectionLayout()

        let item = Observable.just([1, 2, 3, 4])

        item.bind(to: collectionView.rx.items) { (collectionView, row, element) in
            print(element)
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
            cell.configure()
            return cell
        }
        .disposed(by: disposeBag)
    }

    private func setupCollectionLayout() {
        let cellWidth = collectionView.frame.width - 32
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 80, right: 16)
        layout.minimumLineSpacing = 32
        collectionView.collectionViewLayout = layout
    }
}


