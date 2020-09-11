//
//  InitialViewController.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos

class InitialViewController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func internalGalleryAction(_ sender: Any) {
          PHPhotoLibrary.requestAuthorization({ (newStatus) in
              if (newStatus == PHAuthorizationStatus.authorized) {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(GalleryConfigurator.create(), animated: true)
                }
              }
              else {
                  DispatchQueue.main.async {
                    let alertController = UIAlertController (title: Text.alertSettingsTitle.localized, message: Text.goToSettings.localized, preferredStyle: .alert)

                    let settingsAction = UIAlertAction(title: Text.titleSettings.localized, style: .default) { (_) -> Void in

                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                }
                alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: Text.alertCancelTitle.localized , style: .default, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
              }
            }
          })
        
    }
}
