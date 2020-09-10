//
//  ImagePreviewPresenter.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 10.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import Photos

protocol ImagePreviewPresenterProtocol: class {
    var delegate: ImagePreviewViewProtocol? { get set }
    var asset: PHAsset { get }
}

class ImagePreviewPresenter: ImagePreviewPresenterProtocol {
    let asset: PHAsset
    weak var delegate: ImagePreviewViewProtocol?
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}
