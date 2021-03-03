//
//  Person.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

struct Person: Equatable, CustomStringConvertible {
  var name: String {
    guard (0..<26).contains(id), let unicode = UnicodeScalar(id + 65) else {
      return "\(id)"
    }
    return "\(String(unicode))"
  }
  let id: Int
  let isCovidPositive: Bool

  var description: String {
    return "Name: \(name), ID: \(id), Covid: \(isCovidPositive)"
  }

  static func == (lhs: Person, rhs: Person) -> Bool {
    return lhs.id == rhs.id
  }
}
