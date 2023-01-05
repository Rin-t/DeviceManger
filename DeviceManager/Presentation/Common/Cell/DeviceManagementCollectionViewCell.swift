//
//  DeviceManagementCollectionViewCell.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/05.
//

import Foundation
import UIKit

final class DeviceManagementCollectionViewCell: UICollectionViewCell {

    static let identifier = "DeviceManagementCollectionViewCell"
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    func configure() {
        
    }
}
