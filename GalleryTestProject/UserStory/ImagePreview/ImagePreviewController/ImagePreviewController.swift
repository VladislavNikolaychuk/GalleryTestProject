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
    
    @IBOutlet weak var previewImage: UIImageView!
    var presenter: ImagePreviewPresenterProtocol?
    var  itemSize = UIScreen.main.bounds.width/3  - 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        guard let asset = presenter?.asset else {
            return
        }
        loadImage(with: asset) { (image) in
            self.previewImage.image = image
        }
    }
    func loadImage(with asset: PHAsset, completion: @escaping ((UIImage?) -> Void)) {
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: itemSize, height: itemSize),
            contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                completion(image)
        }
    }
}

extension ImagePreviewController: ImagePreviewViewProtocol {}
    
    
