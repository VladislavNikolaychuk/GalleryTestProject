//
//  GalleryPresenter.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import Foundation
import Photos

protocol GalleryPresenterProtocol: class {
    var delegate: GalleryViewProtocol? { get set }
    func viewDidLoad()
}

class GalleryPresenter: GalleryPresenterProtocol {
    var delegate: GalleryViewProtocol?
    
    func viewDidLoad() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
        delegate?.didGetMediaSuccess(galleryFiles: imagesAndVideos)
    }
}

protocol GalleryViewProtocol: class {
    var presenter: GalleryPresenterProtocol? { get set }
    func didGetMediaSuccess(galleryFiles: PHFetchResult<PHAsset>)
}
