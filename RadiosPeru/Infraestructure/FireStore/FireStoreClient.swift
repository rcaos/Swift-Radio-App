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

extension FireStoreClient {
  
  fileprivate func processDocuments<Element>(documents: [QueryDocumentSnapshot]) -> [Element] where Element: Decodable {
    var results: [Element] = []
    
    do {
      results = try documents.compactMap {
        try $0.data(as: Element.self)
      }
    } catch let error {
      print("Error to read entitie: \(error)")
    }
    
    return results
  }
}

// MARK: - TransferServiceProtocol

extension FireStoreClient: TransferServiceProtocol {
  
  func request<Element>(path: String, type: Element.Type) -> Observable<[Element]> where Element: Decodable {
    return Observable<[Element]>.create { [unowned self] (event) -> Disposable in
      
      let disposable = Disposables.create()
      
      Firestore.firestore().collection(path).getDocuments { [weak self] (querySnapshot, err) in
        guard let strongSelf = self else {
          event.onCompleted()
          return
        }
        
        if let error = err {
          event.onError(error)
        } else {
          
          if let documents = querySnapshot?.documents {
            let entities: [Element] = strongSelf.processDocuments(documents: documents)
            
            print("Readed \(entities.count) Entities from FireStore")
            event.onNext( entities )
          }
          
          event.onCompleted()
        }
      }
      return disposable
    }
  }
  
  func save<Element>(path: String, _ entitie: Element, _ id: String?) -> Observable<String> where Element: Encodable {
        return Observable<String>.create { (event) -> Disposable in
      
      let disposable = Disposables.create()
      
      do {
        var documentRef: DocumentReference?
        try documentRef = Firestore.firestore().collection(path).addDocument(from: entitie) { error in
          if let error = error {
            event.onError(error)
          } else if let id = documentRef?.documentID {
            event.onNext(id)
          }
          event.onCompleted()
        }
      } catch let error {
        event.onError(error)
      }
      
      return disposable
    }
  }
}

// MARK: - DataTransferService

extension FireStoreClient: DataTransferService {
  
  func request<Element>(_ router: EndPoint, _ type: Element.Type) -> Observable<Element> where Element: Decodable {
    return request(path: stationsCollection, type: StationRemote.self)
      .flatMap { result -> Observable<Element> in
        if let isTypeElement = result as? Element {
          return Observable.just( isTypeElement )
        } else {
          return Observable.empty()
        }
        
    }
  }
}
