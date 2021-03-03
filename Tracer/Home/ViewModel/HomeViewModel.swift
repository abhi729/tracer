//
//  HomeViewModel.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol HomeViewModel {
  func didTapStartGame()
}

struct HomeViewModelImpl: HomeViewModel {

  weak var output: HomeViewControllerOutput?

  // MARK:- HomeViewModel implementation
  func didTapStartGame() {
    output?.routeToGameScreen()
  }

}
