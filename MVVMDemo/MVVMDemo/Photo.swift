//
//  Photo.swift
//  MVCDemo
//
//  Created by 李昀 on 2018/9/27.
//  Copyright © 2018 李昀. All rights reserved.
//

import Foundation

struct Photos: Codable {
  let photos: [Photo]
}
struct Photo: Codable {
  let id: Int
  let name: String
  let description: String?
  let created_at: Date
  let image_url: String
  let for_sale: Bool
  let camera: String?
}
