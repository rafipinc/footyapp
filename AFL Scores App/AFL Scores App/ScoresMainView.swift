//
//  ContentView.swift
//  AFL Scores App
//
//  Created by PINCUS, Rafael on 25/5/2024.
//

import SwiftUI

struct ScoresMainView: View {
    @StateObject private var dataService = DataService()
    @StateObject private var viewModel = ScoresMainViewModel()
    let imageMapper = ImageMapper()
    @State private var isRoundPickerPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                roundNavigationView
                
                if let error = dataService.error {
                    ErrorView(error: error, retryAction: { dataService.fetchCurrentRoundGames() })
                } else if dataService.games.isEmpty {
                    ProgressView("Loading games...")
                } else {
                    gamesList
                }
            }
            .navigationTitle("AFL Scores")
        }
        .onAppear {
            dataService.fetchCurrentRoundGames()
        }
    }
    
    private var roundNavigationView: some View {
        HStack {
            Button(action: {
                dataService.fetchPreviousRound()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .disabled(dataService.currentRound == 1)
            .padding()
            
            Spacer()
            
            Button(action: {
                isRoundPickerPresented = true
            }) {
                Text("Round \(dataService.currentRound)")
                    .font(.headline)
            }
            .actionSheet(isPresented: $isRoundPickerPresented) {
                ActionSheet(
                    title: Text("Select Round"),
                    buttons: roundPickerButtons
                )
            }
            
            Spacer()
            
            Button(action: {
                dataService.fetchNextRound()
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var gamesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(dataService.games, id: \.id) { game in
                    GameCard(game: game, imageMapper: imageMapper, viewModel: viewModel, dataService: dataService)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var roundPickerButtons: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = (1...23).map { round in
            .default(Text("Round \(round)")) {
                dataService.fetchGames(forRound: round)
            }
        }
        buttons.append(.cancel())
        return buttons
    }
}

struct GameCard: View {
    let game: Game
    let imageMapper: ImageMapper
    let viewModel: ScoresMainViewModel
    @ObservedObject var dataService: DataService
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Round \(game.round)")
                    .font(.headline)
                Spacer()
                Text(game.venue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            HStack(spacing: 20) {
                TeamView(
                    teamName: game.hteam,
                    score: game.hscore ?? 0,
                    goals: game.hgoals ?? 0,
                    behinds: game.hbehinds ?? 0,
                    image: imageMapper.getHomeImage(for: game) ?? Image("error"),
                    alignment: .leading,
                    lastThreeResults: dataService.lastThreeResults[game.hteamid]
                )
                
                VStack {
                    Text("VS")
                        .font(.title3)
                        .fontWeight(.bold)
                    if game.complete == 100 {
                        Text("Final")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text(game.timestr ?? "TBA")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                TeamView(
                    teamName: game.ateam,
                    score: game.ascore ?? 0,
                    goals: game.agoals ?? 0,
                    behinds: game.abehinds ?? 0,
                    image: imageMapper.getAwayImage(for: game) ?? Image("error"),
                    alignment: .trailing,
                    lastThreeResults: dataService.lastThreeResults[game.ateamid]
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: viewModel.borderChooser(for: game).opacity(0.3), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}

struct TeamView: View {
    let teamName: String
    let score: Int
    let goals: Int
    let behinds: Int
    let image: Image
    let alignment: HorizontalAlignment
    let lastThreeResults: [Bool]?
    
    var body: some View {
        VStack(alignment: alignment, spacing: 4) {
            ZStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                
                if let results = lastThreeResults, results.count == 3 {
                    if results.allSatisfy({ $0 }) {
                        Image("fire") // Use the fire image from assets
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .offset(x: 20, y: 20)
                    } else if results.allSatisfy({ !$0 }) {
                        Text("💩")
                            .font(.system(size: 20))
                            .offset(x: 20, y: 20)
                    }
                }
            }
            
            Text(teamName)
                .font(.headline)
                .lineLimit(1)
            
            Text("\(score)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(goals).\(behinds)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .trailing)
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("An error occurred:")
                .font(.headline)
            Text(error.localizedDescription)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Retry") {
                retryAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct ScoresMainView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresMainView()
    }
}

