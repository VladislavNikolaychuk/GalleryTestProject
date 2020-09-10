//
//  ImagePreviewConfigurator.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 10.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos

class ImagePreviewConfigurator {
    
    static func create(asset: PHAsset) -> UIViewController {
        let view: ImagePreviewViewProtocol = ImagePreviewController()
        let presenter: ImagePreviewPresenterProtocol = ImagePreviewPresenter(asset: asset)
        view.presenter = presenter
        presenter.delegate = view
        return (view as? UIViewController) ?? UIViewController()
    }
    
}
