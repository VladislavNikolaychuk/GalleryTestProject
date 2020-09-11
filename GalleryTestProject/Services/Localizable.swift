//
//  Localizable.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 10.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import Foundation
protocol Localizable {
    var localized: String { get }
}

enum Text: String, Localizable {
    
    case video
    case image
    case goToSettings
    case alertSettingsTitle
    case alertCancelTitle
    case titleSettings
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
}
