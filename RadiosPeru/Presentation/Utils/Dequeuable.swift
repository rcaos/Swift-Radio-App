//
//  Dequeuable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public protocol Dequeuable {
  
  static var dequeuIdentifier: String { get }
}

extension Dequeuable where Self: UIView {
  
  public static var dequeuIdentifier: String {
    return String(describing: self)
  }
  
}

extension UITableViewCell: Dequeuable { }

extension UICollectionViewCell: Dequeuable { }
