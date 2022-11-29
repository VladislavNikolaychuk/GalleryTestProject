//
//  MirrorFlow.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuk on 28.11.2022.
//  Copyright © 2022 Vladislav Nikolaychuck. All rights reserved.
//

import Foundation
import UIKit


class MirrorFlowVC: UIViewController
{

    var pause = false // when MyView is touched, this is flipped
    var totalTime = 0 // incremented each frame, displayed on both screens
    var secondScreenLabel = UILabel(frame: .zero)
    var primaryScreenLabel = UILabel(frame: .zero)
    var secondaryWindow = UIWindow(frame: .zero)
    var _secondaryScreen : UIScreen?


    func secondaryDisplayLinkFired(displaylink : CADisplayLink)
    {
        // if not paused, the counter gets incremented and the value
        // is displayed on the labels in both screens
        if (!self.pause)
        {
            self.totalTime + 1


            self.secondScreenLabel.text = "\(self.totalTime)"
            self.secondScreenLabel.sizeToFit()
            self.secondScreenLabel.center = self.secondaryWindow.center


            self.primaryScreenLabel.text = "\(self.totalTime)"
            self.primaryScreenLabel.sizeToFit()
            self.primaryScreenLabel.center = self.view.center
        }
    }




    func secondaryScreen () -> UIScreen?
    {
        // find the first screen that is not the mainscreen.
        // We hold on to it, so that calling self.secondaryScreen
        // many times should not be too slow
        if (nil == _secondaryScreen)
        {
            let screens = UIScreen.screens
            // no more then one screen means there is no
            // secondary screen
            if (screens.count > 1)
            {
                for aScreen in screens
                {
                    let screen = UIScreen.main as UIScreen
                    if (aScreen as! UIScreen != screen)
                    {
                        _secondaryScreen = aScreen as? UIScreen
                        break
                    }
                }
            }
        }
        return  _secondaryScreen
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()


        // setup the secondary screen if it is already available
        if (nil != self.secondaryScreen())
        {
            self.screenDidConnect(notification: nil)
        }
        else
        {
            self.screenDidDisconnect(notification: nil)
        }


        // in a real application, self needs to be removed as observer
        // in e.g. deinit
        NotificationCenter.default.addObserver(self, selector: Selector("screenDidConnect:"), name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector("screenDidDisconnect:"), name: UIScreen.didDisconnectNotification, object: nil)
    }


    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)


        // use myView to capture touches
//        myView.frame = self.view.bounds
//        myView.delegate = self
//        myView.backgroundColor = UIColor.black
//        self.view.addSubview(myView)


        // a label to display the frame count
        self.primaryScreenLabel.text = "\(totalTime)"
        self.primaryScreenLabel.isUserInteractionEnabled = false
        self.primaryScreenLabel.textColor = UIColor.lightGray
        self.primaryScreenLabel.font = UIFont.systemFont(ofSize: 100)
        self.primaryScreenLabel.sizeToFit()
        self.primaryScreenLabel.center = self.view.center
        self.view.addSubview(self.primaryScreenLabel)
    }


    func screenDidConnect(notification : NSNotification?)
    {
        if let secondScreen = self.secondaryScreen()
        {
            // see MainViewController.m in sample code at:
            // https://developer.apple.com/library/ios/samplecode/GLAirplay/Introduction/Intro.html
            self.secondaryWindow.frame = secondScreen.bounds
            self.secondaryWindow.backgroundColor = UIColor.black


            self.secondaryWindow.makeKeyAndVisible()
            self.secondaryWindow.screen = secondScreen


            self.secondaryWindow .addSubview(self.secondScreenLabel)
            self.secondScreenLabel.text = "\(totalTime)"
            self.secondScreenLabel.textColor = UIColor.lightGray
            self.secondScreenLabel.font = UIFont.systemFont(ofSize: 400)
            self.secondScreenLabel.sizeToFit()
            self.secondScreenLabel.center = self.secondaryWindow.center


            if let secondaryScreenDisplayLink = secondScreen.displayLink(withTarget: self, selector: Selector("secondaryDisplayLinkFired:"))
            {
                secondaryScreenDisplayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            }
            else
            {
                print("WARNING: could not get a displaylink")
            }
        }
        else
        {
            print("PROGRAMMER ERROR: screenDidConnect: called but there is no second screen")
        }
    }
    func screenDidDisconnect(notification : NSNotification?)
    {
        // in a real application, this should be implemented properly
    }
}


//protocol MyViewDelegate
//{
//    func myViewDidBeginTouches(view : MyView,  touches : Set<NSObject>)
//    func myViewDidEndTouches(view : MyView, touches : Set<NSObject>)
//}


//class MyView : UIView
//{
//    var delegate : MyViewDelegate?
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
//    {
//        self.delegate?.myViewDidBeginTouches(view: self, touches: touches)
//    }
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
//    {
//    }
//    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!)
//    {
//        self.delegate?.myViewDidEndTouches(self, touches: touches)
//    }
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
//    {
//        self.delegate?.myViewDidEndTouches(self, touches: touches)
//    }
//}
