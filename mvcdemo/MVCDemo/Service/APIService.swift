//
//  APIService.swift
//  MVCDemo
//
//  Created by 李昀 on 2018/9/27.
//  Copyright © 2018 李昀. All rights reserved.
//

import Foundation
class ApiService {
  // Simulate long waiting for fetching fake api service
  func fetchPopularPhoto(complete: @escaping (_ success: Bool, _ photos: [Photo], _ error: Error?) -> () ){
    
    DispatchQueue.global().async {
      let path = Bundle.main.path(forResource: "content", ofType: "json")!
      let data = try! Data(contentsOf: URL(fileURLWithPath: path))
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let photos = try! decoder.decode(Photos.self, from: data)
      complete(true, photos.photos, nil)
    }
    
  }
  
}
