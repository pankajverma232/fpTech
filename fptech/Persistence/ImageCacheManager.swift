//
//  Utility.swift
//  fptech
//
//  Created by Pankaj Verma on 09/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let imageCache = NSCache<NSString, UIImage>()
    static func  saveImage(image:UIImage, key:String){
        imageCache.setObject(image, forKey: key as NSString)
    }
    static func getImage(url:String)->UIImage?{
        return imageCache.object(forKey: url as NSString)
    }
}
