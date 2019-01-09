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
    var model:NewsModel?

    public func configure(with model: NewsModel) {
        self.model = model
        newsImageView.setImage(url: model.urlToImage)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        urlBtn.setTitle(model.url, for: .normal)
    }
    
    @IBAction   func urlClicked(_ sender:UIButton) {
        if let onClicked = onClicked, let urlString = sender.titleLabel?.text{
            onClicked(urlString)
        }
    }
}
