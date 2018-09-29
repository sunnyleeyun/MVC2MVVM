//
//  PhotoListViewModel.swift
//  MVVMDemo
//
//  Created by 李昀 on 2018/9/28.
//  Copyright © 2018 李昀. All rights reserved.
//

import Foundation

class PhotoListViewModel {
  
  let apiService: APIServiceProtocol
  
  private var photos: [Photo] = [Photo]()
  
  private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel](){
    didSet{
      self.reloadTableViewClosure?()
    }
  }
  
  var numberOfCells: Int {
    return cellViewModels.count
  }
  
  var isLoading: Bool = false {
    didSet {
      self.updateLoadingStatus?()
    }
  }
  
  var alertMessage: String? {
    didSet {
      self.showAlertClosure?()
    }
  }
  
  var isAllowSegue: Bool = false
  var selectedPhoto: Photo?
  
  var reloadTableViewClosure: ( () -> () )?
  var updateLoadingStatus: ( () -> () )?
  var showAlertClosure: ( () -> () )?
  
  init(apiService: APIServiceProtocol = ApiService()) {
    self.apiService = apiService
  }
  
  func initFetch(){
    self.isLoading = true
    apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
      self?.isLoading = false
      if let error = error {
        self?.alertMessage = error.rawValue
      } else {
        self?.processFetchedPhoto(photos: photos)
      }
    }
  }

  func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel {
    return cellViewModels[indexPath.row]
  }
  
  private func processFetchedPhoto(photos: [Photo]){
    self.photos = photos // cache
    var photoListCellViewModels = [PhotoListCellViewModel]()
    for photo in photos {
      photoListCellViewModels.append(createCellViewModel(photo: photo))
    }
    self.cellViewModels = photoListCellViewModels
  }
  
  private func createCellViewModel(photo: Photo) -> PhotoListCellViewModel {
    var descTextContainer: [String] = [String]()
    if let camera = photo.camera {
      descTextContainer.append(camera)
    }
    if let description = photo.description {
      descTextContainer.append(description)
    }
    let desc = descTextContainer.joined(separator: "-")
    
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd"
    
    return PhotoListCellViewModel(titleText: photo.name,
                                  descText: desc,
                                  imageUrl: photo.image_url,
                                  dateText: dateformatter.string(from: photo.created_at))
  }
  
}

extension PhotoListViewModel {
  func userPressed(at indexPath: IndexPath){
    let photo = self.photos[indexPath.row]
    if photo.for_sale {
      self.isAllowSegue = true
      self.selectedPhoto = photo
    } else {
      self.isAllowSegue = false
      self.selectedPhoto = nil
      self.alertMessage = "This item is not for sale"
    }
  }
}

struct PhotoListCellViewModel {
  let titleText: String
  let descText: String
  let imageUrl: String
  let dateText: String
}
