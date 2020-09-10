//
//  InitialViewController.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit

class InitialViewController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func internalGalleryAction(_ sender: Any) {
        self.navigationController?.pushViewController(GalleryConfigurator.create(), animated: true)
    }
}
