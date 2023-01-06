//
//  ManageAndroidDeviceViewContrller.swift
//  DeviceManager
//
//  Created by Rin on 2022/12/25.
//

import UIKit

final class ManageAndroidDeviceViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.layer.cornerRadius = 10
        }
    }

}
