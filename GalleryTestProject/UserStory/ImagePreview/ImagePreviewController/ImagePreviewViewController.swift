
//
//  ImagePreviewController.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 10.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos

protocol ImagePreviewViewProtocol: class {
    var presenter: ImagePreviewPresenterProtocol? { get set }
}

class ImagePreviewController: UIViewController {
    
    var imageScrollView: ImageScrollView!
    var presenter: ImagePreviewPresenterProtocol?
    var newImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        guard let asset = presenter?.asset else {return}
        loadImage(with: asset) { (image) in
            guard let image = image else {return}
            self.newImage = image
            self.imageScrollView.set(image: image)
        }
    }

    func loadImage(with asset: PHAsset, completion: @escaping ((UIImage?) -> Void)) {
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 0, height: 0),
            contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                completion(image)
        }
    }
    
    func setupImageScrollView() {
        setupShareButton()
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func setupShareButton() {
        let button = UIBarButtonItem(title: Text.share.localized,
                                     style: .plain, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func shareAction() {
        guard let image = newImage else {return}
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
}

extension ImagePreviewController: ImagePreviewViewProtocol {}
