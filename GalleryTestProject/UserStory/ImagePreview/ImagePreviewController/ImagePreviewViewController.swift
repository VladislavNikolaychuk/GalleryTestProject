
//
//  ImagePreviewController.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 10.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import Photos
import AVKit
import MediaPlayer

protocol ImagePreviewViewProtocol: class {
    var presenter: ImagePreviewPresenterProtocol? { get set }
}

class ImagePreviewController: UIViewController {
    
    var imageScrollView: ImageScrollView!
    var presenter: ImagePreviewPresenterProtocol?
    var newImage: UIImage?
    
    var secondWindow: UIWindow?
    var secondScreenView: UIView?
    var externalLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightButton()
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        setupScreen()
        guard let asset = presenter?.asset else {return}
        loadImage(with: asset) { (image) in
            guard let image = image else {return}
            self.newImage = image
            self.imageScrollView.set(image: image)
        }
    }
    
    @objc func setupScreen() {
        print("UIScreen.screens.count \(UIScreen.screens.count)")
        if UIScreen.screens.count > 1 {
//            let secondScreen = UIScreen.screens[1]
//            let screenBounds = secondScreen.bounds
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.secondWindow = UIWindow(frame: screenBounds)
//            appDelegate.secondWindow?.screen = secondScreen
//            appDelegate.secondWindow?.isHidden = false
//
//            let viewController = UIViewController()
//            viewController.view.backgroundColor = .green
//            appDelegate.secondWindow?.rootViewController = viewController
            
//            secondWindow = UIWindow(frame: secondScreen.bounds)
//            let viewController = UIViewController()
//            secondScreenView?.window?.rootViewController = viewController
//            secondWindow?.screen = secondScreen
//            secondScreenView = UIView(frame: secondWindow!.frame)
//            secondWindow?.addSubview(secondScreenView!)
//            secondWindow?.isHidden = false
//            secondScreenView?.backgroundColor = UIColor.white
//            externalLabel.textAlignment = .center
//            externalLabel.font = UIFont(name: "Helvetica", size: 50.0)
//            externalLabel.frame = secondScreenView!.bounds
//            externalLabel.text = "HI Mark"
//            secondScreenView!.addSubview(externalLabel)
            
        }
    }
    
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

    func loadImage(with asset: PHAsset, completion: @escaping ((UIImage?) -> Void)) {
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 0, height: 0),
            contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                completion(image)
        }
    }
    
    func setupImageScrollView() {
//        setupShareButton()
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
//    func setupShareButton() {
//        let button = UIBarButtonItem(title: Text.share.localized,
//                                     style: .plain, target: self, action: #selector(shareAction))
//        self.navigationItem.rightBarButtonItem = button
//    }
//
//    @objc private func shareAction() {
//        guard let image = newImage else {return}
//        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//        self.present(ac, animated: true)
//    }
    
}

extension ImagePreviewController: ImagePreviewViewProtocol {}
