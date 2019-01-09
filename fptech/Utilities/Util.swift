//
//  Util.swift
//  fptech
//
//  Created by Pankaj Verma on 09/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(url: String?) {
        guard let url = url else {
            return
        }
        var imageDownloadTask:URLSessionDataTask?
        if let image = ImageCacheManager.getImage(url: url) {
            self.image = image
            return
        }
        self.image = UIImage(named: "default")
        imageDownloadTask = URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, response
            , error) in
            if error == nil {
                if let data = data, let image = UIImage(data: data){
                    ImageCacheManager.saveImage(image: image, key: url)
                    DispatchQueue.main.async {[weak self] in
                        self?.image = image
                    }
                }
            }
        }
        imageDownloadTask?.resume()
    }
}

