//
//  UIViewController+Extension.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/16.
//

import UIKit

extension UIViewController {

    func showAlert(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    func showDestructiveAlert(message: String, completion: (() -> Void)?) {
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
