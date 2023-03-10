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

    @IBOutlet private weak var roundedView: UIView!
    @IBOutlet private weak var colorLabel: UILabel!
    @IBOutlet private weak var deviceName: UILabel!
    @IBOutlet private weak var holderLabel: UILabel!
    @IBOutlet private weak var deviceVersionLabel: UILabel!
    @IBOutlet private weak var accountNameLabel: UILabel!
    
    func configure(data: DeviceDataEntity) {
        setupLayout()
        setupOutlet(data: data)
    }

    private func setupLayout() {
        roundedView.layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 4
        clipsToBounds = false
        layer.cornerRadius = 10
    }

    private func setupOutlet(data: DeviceDataEntity) {
        colorLabel.text = data.color
        deviceName.text = data.device
        holderLabel.text = data.holder
        deviceVersionLabel.text = data.version
        accountNameLabel.text = data.accountName
    }
}
