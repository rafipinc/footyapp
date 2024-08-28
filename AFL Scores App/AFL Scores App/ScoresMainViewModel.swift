//
//  ScoresMainViewModel.swift
//  AFL Scores App
//
//  Created by PINCUS, Rafael on 1/6/2024.
//

import SwiftUI

class ScoresMainViewModel: ObservableObject {
    @StateObject private var dataService = DataService()
    
    func borderChooser(for game: Game) -> Color {
        if game.complete == 100 {
            return Color.green
        }
            else {
            return Color.black
        }
    }
}
