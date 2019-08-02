//
//  UIKitResizeImageSwift.swift
//  ResizeImageApp2
//
//  Created by Uber on 20/07/2019.
//  Copyright © 2019 RXMobile. All rights reserved.
//

import Foundation
import UIKit

class UIKitResizeImageSwift: NSObject {
    
    @objc internal static func resizeImage(_ image: UIImage, forSize: CGSize) -> UIImage? {
     
        var scaledImg : UIImage? = nil
        let rectForNewSize = CGRect(origin: .zero, size: forSize)

        if #available(iOS 10, *) {
            let renderer = UIGraphicsImageRenderer(size: forSize)
            scaledImg = renderer.image { (context) in
                image.draw(in: rectForNewSize)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(forSize, false, UIScreen.main.scale)
            image.draw(in: rectForNewSize)
            scaledImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
        }
        return scaledImg
    }
    
}
