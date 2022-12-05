//
//  TFModels.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuk on 05.12.2022.
//  Copyright © 2022 Vladislav Nikolaychuck. All rights reserved.
//

import Foundation

enum ModelType: CaseIterable {
  case efficientDetLite0
  case efficientDetLite1
  case efficientDetLite2
  case ssdMobileNetV1

  var modelFileInfo: FileInfo {
    switch self {
    case .ssdMobileNetV1:
      return FileInfo("ssd_mobilenet_v1", "tflite")
    case .efficientDetLite0:
      return FileInfo("efficientdet_lite0", "tflite")
    case .efficientDetLite1:
      return FileInfo("efficientdet_lite1", "tflite")
    case .efficientDetLite2:
      return FileInfo("efficientdet_lite2", "tflite")
    }
  }

  var title: String {
    switch self {
    case .ssdMobileNetV1:
      return "SSD-MobileNetV1"
    case .efficientDetLite0:
      return "EfficientDet-Lite0"
    case .efficientDetLite1:
      return "EfficientDet-Lite1"
    case .efficientDetLite2:
      return "EfficientDet-Lite2"
    }
  }
}

/// Default configuration
struct ConstantsDefault {
  static let modelType: ModelType = .efficientDetLite0
  static let threadCount = 1
  static let scoreThreshold: Float = 0.5
  static let maxResults: Int = 3
  static let theadCountLimit = 10
}
