//
//  FireStoreClient.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Firebase
import FirebaseFirestoreSwift

class FireStoreClient {
  
  let stationsCollection: String
  
  init(stationsCollection: String) {
    self.stationsCollection = stationsCollection
  }
  
}

// MARK: - DataTransferService

extension FireStoreClient: DataTransferService {
  
  func request<Element>(_ router: EndPoint, _ decodingType: Element.Type) -> Observable<Element> where Element: Decodable {
    return Observable<Element>.create { [unowned self] (event) -> Disposable in
      
      let disposable = Disposables.create()
      
      Firestore.firestore().collection(self.stationsCollection).getDocuments { [weak self] (querySnapshot, err) in
        guard let strongSelf = self else {
          event.onCompleted()
          return
        }
        
        if let error = err {
          event.onError(error)
        } else {
          
          if let documents = querySnapshot?.documents {
            let stations = strongSelf.processDocuments(documents: documents)
            
            print("Readed \(stations.count) stations from FireStore")
            if let result = StationResult(stations: stations) as? Element {
              event.onNext( result )
            }
            
          }
          
          event.onCompleted()
        }
      }
      return disposable
    }
  }
  
  fileprivate func processDocuments(documents: [QueryDocumentSnapshot]) -> [StationRemote] {
    var results: [StationRemote] = []
    
    do {
      results = try documents.compactMap {
        try $0.data(as: StationRemote.self)
      }
    } catch let error {
      print("Error to read Station: \(error)")
    }
    
    return results
  }
}
