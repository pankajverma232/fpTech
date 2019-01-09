//
//  NewsModel.swift
//  fptech
//
//  Created by Pankaj Verma on 08/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import Foundation

struct Root : Decodable {
    let totalResults : Int?
    let status : String?
    let articles : [NewsModel]?
}


struct NewsModel:Decodable {
    let source:Source?
    let author:String?
    let title: String?
    let description:String?
    let urlToImage:String?
    let url: String?
    let publishedAt:String?
    let content:String?
}

struct Source:Decodable {
    let newsId:String?
    let name:String?
    private enum CodingKeys: String, CodingKey {
        case newsId = "id"
        case name = "name"
    }
}
