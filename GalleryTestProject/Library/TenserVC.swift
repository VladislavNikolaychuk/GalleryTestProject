//
//  TenserVC.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuk on 05.12.2022.
//  Copyright © 2022 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit
import MobileVLCKit
import TensorFlowLiteTaskVision
import SnapKit

class TenserVC: UIViewController {
    var overlayView : OverlayView = {
        var overlay = OverlayView()
        overlay.backgroundColor = .clear
        return overlay
    }()
    var mainVideoView = UIView()
    var insideVideoView = UIView()
    var streamImage = UIImageView()
    
    
    private var objectDetectionHelper: ObjectDetectionHelper? = ObjectDetectionHelper(
      modelFileInfo: ConstantsDefault.modelType.modelFileInfo,
      threadCount: ConstantsDefault.threadCount,
      scoreThreshold: ConstantsDefault.scoreThreshold,
      maxResults: ConstantsDefault.maxResults
    )
    private let edgeOffset: CGFloat = 2.0
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    private var result: Result?
    var frameTimer: Timer?
    var videoPlayer = VLCMediaPlayer()
    private let colors = [
      UIColor.red,
      UIColor(displayP3Red: 90.0 / 255.0, green: 200.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0),
      UIColor.green,
      UIColor.orange,
      UIColor.blue,
      UIColor.purple,
      UIColor.magenta,
      UIColor.yellow,
      UIColor.cyan,
      UIColor.brown,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.clearsContextBeforeDrawing = true
        self.view.addSubview(self.mainVideoView)
        self.mainVideoView.snp.makeConstraints { make in
            make.trailing.bottom.top.leading.equalToSuperview()
        }
        self.mainVideoView.addSubview(self.insideVideoView)
        self.insideVideoView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(1)
        }
        self.insideVideoView.addSubview(self.streamImage)
        self.streamImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.insideVideoView.addSubview(self.overlayView)
        self.overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        getStreamFromDevice()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let result = updateVideoView(frame: mainVideoView.frame, motionVideoRatio: .fourToThree)
        insideVideoView.snp.updateConstraints { make in
            make.height.equalTo(result.height)
            make.width.equalTo(result.width)
        }
    }
    
    func getStreamFromDevice() {
        self.videoPlayer.delegate = self
        guard let url = URL(string: "rtsp://obsidian5.local/live") else {return}
        let media = VLCMedia(url: url)
        media.addOption("codec=avcodec,all")
        media.addOption("no-audio")
        media.addOptions([
            "network-caching": 300,
            "live-caching": 0,
            "rtp-caching": 0,
            "rtsp-caching": 0,
            "hardware-decoding": false,
            "realrtsp-caching": 0,
            "avcodec": false,
            "skip-frames": 0
        ])
        videoPlayer.media = media
        videoPlayer.drawable = self.streamImage
        videoPlayer.play()
        timer()
    }
    
    
    func timer() {
        frameTimer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true, block: { (Timer) in
            if Timer.isValid {
                autoreleasepool { () -> Void in
                    guard let castPlayer = self.videoPlayer.drawable as? UIView else {return}
                    let size = castPlayer.frame.size
                    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                    let rec = castPlayer.frame
                    castPlayer.drawHierarchy(in: rec, afterScreenUpdates: false)
                    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return}
                    UIGraphicsEndImageContext();
                    guard let buff = image.pixelBuffer() else {return}
                    self.detect(pixelBuffer: buff)
                }
            }
        })
    }
    
    func detect(pixelBuffer: CVPixelBuffer) {
      result = self.objectDetectionHelper?.detect(frame: pixelBuffer)
      guard let displayResult = result else {
        return
      }

      let width = CVPixelBufferGetWidth(pixelBuffer)
      let height = CVPixelBufferGetHeight(pixelBuffer)

      DispatchQueue.main.async {
        self.drawAfterPerformingCalculations(
          onDetections: displayResult.detections,
          withImageSize: CGSize(width: CGFloat(width), height: CGFloat(height)))
      }
    }
    
    
    
    func draw(objectOverlays: [ObjectOverlay]) {
      self.overlayView.objectOverlays = objectOverlays
      self.overlayView.setNeedsDisplay()
    }
    
    func drawAfterPerformingCalculations(
      onDetections detections: [Detection], withImageSize imageSize: CGSize) {
      self.overlayView.objectOverlays = []
      self.overlayView.setNeedsDisplay()

      guard !detections.isEmpty else {
        return
      }
          print("HAVE DETECTION!!! :)))))")

      var objectOverlays: [ObjectOverlay] = []

      for detection in detections {

        guard let category = detection.categories.first else { continue }
        // Translates bounding box rect to current view.
        var convertedRect = detection.boundingBox.applying(
          CGAffineTransform(
            scaleX: self.overlayView.bounds.size.width / imageSize.width,
            y: self.overlayView.bounds.size.height / imageSize.height))

        if convertedRect.origin.x < 0 {
          convertedRect.origin.x = self.edgeOffset
        }

        if convertedRect.origin.y < 0 {
          convertedRect.origin.y = self.edgeOffset
        }

        if convertedRect.maxY > self.overlayView.bounds.maxY {
          convertedRect.size.height =
            self.overlayView.bounds.maxY - convertedRect.origin.y - self.edgeOffset
        }

        if convertedRect.maxX > self.overlayView.bounds.maxX {
          convertedRect.size.width =
            self.overlayView.bounds.maxX - convertedRect.origin.x - self.edgeOffset
        }

        let objectDescription = String(
          format: "\(category.label ?? "Unknown") (%.2f)",
          category.score)

        let displayColor = colors[category.index % colors.count]

        let size = objectDescription.size(withAttributes: [.font: self.displayFont])

        let objectOverlay = ObjectOverlay(
          name: objectDescription, borderRect: convertedRect, nameStringSize: size,
          color: displayColor,
          font: self.displayFont)

        objectOverlays.append(objectOverlay)
      }

      // Hands off drawing to the OverlayView
      self.draw(objectOverlays: objectOverlays)

    }
    enum MotionVideoRatio {
        case fourToThree
        case sixteenToNine
    }

    func updateVideoView(frame: CGRect, motionVideoRatio: MotionVideoRatio) -> CGRect {
        var result: CGRect = .zero
        switch motionVideoRatio {
        case .fourToThree:
            if frame.width > frame.height {
                result = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 3 / 4)
            } else {
                result = CGRect(x: 0, y: 0, width: frame.width, height: frame.width * 3 / 4)
            }
        case .sixteenToNine:
            result = CGRect(x: 0, y: 0, width: frame.width, height: frame.width * 9 / 16)
        }
        return result
    }

}

extension TenserVC: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification) {
        switch self.videoPlayer.state {
        case .stopped:
            break
        case .opening:
            break
        case .buffering:
            print("fBUFFER")
            break
        case .ended:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.getStreamFromDevice()
            }
            print("ended")
            break
        case .error:
            print("error")
            break
        case .playing:
            print("playing")
            break
        case .paused:
            break
        case .esAdded:
            break
        @unknown default:
            break
        }
    }
    
    
}

extension UIImage {

    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return resizedImage
    }

    func cropToSquare() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        var imageHeight = self.size.height
        var imageWidth = self.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let x = ((CGFloat(cgImage.width) - size.width) / 2).rounded()
        let y = ((CGFloat(cgImage.height) - size.height) / 2).rounded()

        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let croppedCgImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCgImage, scale: 0, orientation: self.imageOrientation)
        }

        return nil
    }
    
    

    func pixelBuffer() -> CVPixelBuffer? {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32BGRA,
                                         attrs,
                                         &pixelBuffer)

        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }

        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return resultPixelBuffer
    }
}
