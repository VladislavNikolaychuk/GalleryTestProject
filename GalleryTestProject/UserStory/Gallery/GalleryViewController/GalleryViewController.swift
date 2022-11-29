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
import MediaPlayer


class GalleryViewController: BaseController {
    
    @IBOutlet weak var galleryCollection: GalleryCollectionView!
    var presenter: GalleryPresenterProtocol?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        addRightButton1()
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
    
    func screenirror() {}
    
    func addRightButton(){
        
        let buttonView  = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let routerPickerView = AVRoutePickerView(frame: buttonView.bounds)
         routerPickerView.tintColor = UIColor.red
         routerPickerView.activeTintColor = .white
         buttonView.addSubview(routerPickerView)
        let rightBarButton = UIBarButtonItem(customView: buttonView)
        self.navigationItem.rightBarButtonItem = rightBarButton

   }
    
    func addRightButton1(){
        let buttonView  = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let routerPickerView =  MPVolumeView(frame: buttonView.bounds)
        routerPickerView.tintColor = UIColor.green
        routerPickerView.showsVolumeSlider = false
        buttonView.addSubview(routerPickerView)
        let rightBarButton = UIBarButtonItem(customView: buttonView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func showAirplay() {
        let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        airplayVolume.showsVolumeSlider = false
        self.view.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
    }
    
    func asdsa() {

    }
    
    

    
    func openImageController(asset: PHAsset) {
        
        let controller = ImagePreviewConfigurator.create(asset: asset)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func playVideo(asset: PHAsset) {
        guard asset.mediaType == .video else {
            let optionsImg = PHImageRequestOptions()
            PHCachingImageManager().requestImage(for: asset, targetSize: asset.accessibilityFrame.size, contentMode: .aspectFill, options: optionsImg) { img, info in
                DispatchQueue.main.async {
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = AVPlayer()
                    playerViewController.showsPlaybackControls = true
                    playerViewController.player!.allowsExternalPlayback = true
                    self.present(playerViewController, animated: true) {
                        playerViewController.player?.play()
                    }
                }
            }
            return
        }

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHCachingImageManager().requestPlayerItem(forVideo: asset, options: options) { (playerItem, info) in
            DispatchQueue.main.async {
                let playerViewController = AVPlayerViewController()
                let avPlayer = AVPlayer(playerItem: playerItem)
                playerViewController.player = avPlayer
                playerViewController.showsPlaybackControls = true
                playerViewController.player!.allowsExternalPlayback = true
                
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

