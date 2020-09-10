//
//  GalleryConfigurator.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 10.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit

class GalleryConfigurator {
    
    static func create() -> UIViewController {
        let presenter: GalleryPresenterProtocol = GalleryPresenter()
        let view: GalleryViewProtocol = GalleryViewController()
        view.presenter = presenter
        presenter.delegate = view
        return (view as? UIViewController) ?? UIViewController()
    }
    
}
