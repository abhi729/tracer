//
//  Status+Equatable.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

extension Status: Equatable {

  static func == (lhs: Status, rhs: Status) -> Bool {
    switch (lhs, rhs) {
    case (.notStarted, .notStarted):
        return true
    case (.inProgress, .inProgress):
      return true
    case (.completed(let err1), .completed(error: let err2)):
      if err1 == nil && err2 == nil {
        return true
      } else {
        if err1 != nil && err2 != nil {
          return err1! == err2
        } else {
          return false
        }
      }
    default:
      return false
    }
  }

}
