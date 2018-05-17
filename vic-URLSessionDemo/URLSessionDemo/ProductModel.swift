//
//  ProductModel.swift
//  URLSessionDemo
//
//  Created by vic_liu on 2018/4/27.
//  Copyright © 2018年 vic_liu. All rights reserved.
//

import Foundation
struct product: Codable {
    var name: String
    var description: String
    var price: Int
    var dixcount: Double
}
struct productResult: Codable { //Codable JSONDecoder專用格式
    var api_version: String
    var products: [product]
}
