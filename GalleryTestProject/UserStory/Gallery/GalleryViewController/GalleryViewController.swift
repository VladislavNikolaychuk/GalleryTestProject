//
//  GalleryViewController.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos
import AVKit

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
            self?.playVideo(asset: asset)
            
        }
    }
    
    func openImageController(asset: PHAsset) {
        let controller = ImagePreviewConfigurator.create(asset: asset)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func playVideo(asset: PHAsset) {
        guard asset.mediaType == .video else {
            return
        }
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHCachingImageManager().requestPlayerItem(forVideo: asset, options: options) { (playerItem, info) in
            DispatchQueue.main.async {
                let playerViewController = AVPlayerViewController()
                playerViewController.player = AVPlayer(playerItem: playerItem)
                self.present(playerViewController, animated: true) {
                    playerViewController.player?.play()
                }
            }
        }
    }
}

extension GalleryViewController: GalleryViewProtocol {
    
    func didGetMediaSuccess(galleryFiles: PHFetchResult<PHAsset>) {
        galleryCollection.mediaFiles = galleryFiles
    }
}

