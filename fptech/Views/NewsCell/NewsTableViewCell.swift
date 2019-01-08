//
//  NewsTableViewCell.swift
//  fptech
//
//  Created by Pankaj Verma on 08/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    var onClicked:((String) -> ())?
    var imageDownloadTask:URLSessionDataTask?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    public func configure(with model: NewsModel) {
        if let urlString = model.urlToImage{
            if let imgUrl = URL.init(string: urlString){
                downloadImage(url: imgUrl) { (image, error) in
                    if error == nil{
                        DispatchQueue.main.async {
                            self.newsImageView.image = image
                        }
                    }
                }
            }
        }
        
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        urlBtn.setTitle(model.url, for: .normal)
    }
    
    
    
    
    let imageCache = NSCache<NSString, UIImage>()
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            imageDownloadTask = URLSession.shared.dataTask(with: url) { (data, response
                , error) in
                if let error = error {
                    completion(nil, error)
                    
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                }
            }
            
            imageDownloadTask?.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
        
    }
    
    @IBAction   func urlClicked(_ sender:UIButton) {
        if let onClicked = onClicked, let urlString = sender.titleLabel?.text{
        onClicked(urlString)
        }
    }
}
