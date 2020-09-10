//
//  GalleryCollectionView.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos

class GalleryCollectionView: UICollectionView {
    
    let itemSize = UIScreen.main.bounds.width/3  - 10
    var mediaFiles: PHFetchResult<PHAsset>? {
        didSet {
            self.reloadData()
        }
    }
     var imageDidTap: ((PHAsset) -> Void)?
     var videoDidTap: ((PHAsset) -> Void)?
    
    func loadImage(with asset: PHAsset, completion: @escaping ((UIImage?) -> Void)) {
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: itemSize, height: itemSize),
            contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                completion(image)
        }
    }
    
}

extension GalleryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaFiles?.count ?? 0
    }
    
    func numberOfSections (in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentify.galleryCell.rawValue, for: indexPath) as? GalleryCell,
            let fileAsset = mediaFiles?[indexPath.row] else {
                return UICollectionViewCell()
        }
        
        itemCell.imageView.image = nil
        loadImage(with: fileAsset) { (image) in
            itemCell.imageView.image = image
        }
        switch fileAsset.mediaType {
        case .video:
            itemCell.typeCellLabel.text = Text.video.localized
            itemCell.goToFullScreen = { [weak self] in
                self?.videoDidTap?(fileAsset)
            }
        case .image:
            itemCell.typeCellLabel.text = Text.image.localized
            itemCell.goToFullScreen = { [weak self] in
                self?.imageDidTap?(fileAsset)
            }
        default:
            break
        }
        return itemCell
    }
    
}
