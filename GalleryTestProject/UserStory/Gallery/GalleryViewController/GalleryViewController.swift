//
//  GalleryViewController.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: BaseController {
    
    @IBOutlet weak var galleryCollection: GalleryCollectionView!
    var presenter: GalleryPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        galleryCollection.register(UINib(nibName: "GalleryCell", bundle: nil),
                                   forCellWithReuseIdentifier: CellIdentify.galleryCell.rawValue)
        galleryCollection.dataSource = galleryCollection
        galleryCollection.delegate = galleryCollection
        galleryCollection.imageDidTap = { [weak self] asset in
            self?.openImageController(asset: asset)
        }
        galleryCollection.videoDidTap = { [weak self] asset in
        }
    }
    
    func openImageController(asset: PHAsset) {
        let controller = ImagePreviewConfigurator.create(asset: asset)
        self.present(controller, animated: true, completion: nil)
    }

}

extension GalleryViewController: GalleryViewProtocol {
    
    func didGetMediaSuccess(galleryFiles: PHFetchResult<PHAsset>) {
        galleryCollection.mediaFiles = galleryFiles
    }
}

