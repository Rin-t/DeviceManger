//
//  TopTabbarController.swift
//  DeviceManager
//
//  Created by Rin on 2022/12/25.
//


import UIKit

final class TopTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .clear
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().backgroundColor = .systemGray5

        setViewControllers([
            setupManageiOSDeviceViewController(),
            setupManageAndroidDeviceViewController()
        ], animated: false)
    }

    private func setupManageiOSDeviceViewController() -> UIViewController {
        let vc = ManageiOSDeviceViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = .init(title: "iOS", image: UIImage(systemName: "applelogo"), tag: 0)
        nav.navigationItem.title = "iOS"
        return nav
    }

    private func setupManageAndroidDeviceViewController() -> UIViewController {
        let vc = ManageAndroidDeviceViewController()
        let nav = UINavigationController(rootViewController: vc)
        let image = UIImage(named: "android")
        let reSizeImage = image?.resize(size: CGSize(width: 24, height: 24))
        nav.tabBarItem = .init(title: "Android", image: reSizeImage, tag: 1)
        nav.title = "Android"
        return nav
    }
    
}

private extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
