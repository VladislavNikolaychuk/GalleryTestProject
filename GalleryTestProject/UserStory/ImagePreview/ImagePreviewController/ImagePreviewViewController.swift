
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        
        guard let asset = presenter?.asset else {
            return
        }
        
        loadImage(with: asset) { (image) in
            guard let image = image else {
                return
            }
            var imageImage = UIImage(named: "devel.jpg")
            self.imageScrollView.set(image: imageImage!)
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
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension ImagePreviewController: ImagePreviewViewProtocol {}


