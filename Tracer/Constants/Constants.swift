//
//  Constants.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

struct Constants {

  // HomeScreen
  static let welcomeText = "Welcome to COVID Tracer Game"
  static let instructions =
  """
  A group of persons will be displayed on the screen.
  Then a path will be shown for 5 seconds which will depict how the spread can be traced among these people.
  After 5 seconds you are supposed to retrace the steps which was shown to you.
  You can tap on a person to chose that person for tracing. The sequence should be exactly as it was shown to you.
  For every correct person selected you will be given 10 points and 10 points will be deducted from your score if the person selected was wrong.
  You will have 3 lives to begin with.
  There are 20 levels in the game, 1 being the easiest and 20 being the hardest.
  Good luck!!!
  """
  static let startGameButtonTitle = "START GAME"
  static let homeToGameSegue = "HomeToGame"

}
