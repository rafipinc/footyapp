//
//  DataService.swift
//  AFL Scores App
//
//  Created by PINCUS, Rafael on 25/5/2024.
//

import Foundation
class DataService: ObservableObject {
    @Published var games: [Game] = []
    @Published var error: Error?
    @Published var currentRound: Int = 1
    @Published var previousRoundResults: [Int: Bool] = [:]  // teamId: didWin
    @Published var lastThreeResults: [Int: [Bool]] = [:] // teamId: [last3Results]

    private let baseURL = "https://api.squiggle.com.au"
    
    func fetchCurrentRoundGames() {
        fetchGames(forRound: currentRound)
    }
    
    func fetchNextRound() {
        currentRound += 1
        fetchGames(forRound: currentRound)
    }
    
    func fetchPreviousRound() {
        if currentRound > 1 {
            currentRound -= 1
            fetchGames(forRound: currentRound)
        }
    }
    
    func fetchGames(forRound round: Int) {
        currentRound = round
        let urlString = "\(baseURL)/?q=games;year=\(Calendar.current.component(.year, from: Date()));round=\(round)"
        fetchGames(urlString: urlString)
    }
    
    private func fetchGames(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.error = error
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "No data received", code: 0, userInfo: nil)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let gameResponse = try decoder.decode(GameResponse.self, from: data)
                DispatchQueue.main.async {
                    self.games = gameResponse.games
                    self.updateLastThreeResults(for: gameResponse.games)
                    self.error = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
        task.resume()
    }
    
    private func updateLastThreeResults(for games: [Game]) {
        for game in games {
            if game.complete == 100 {
                updateTeamResults(teamId: game.hteamid, won: game.hteamid == game.winnerteamid)
                updateTeamResults(teamId: game.ateamid, won: game.ateamid == game.winnerteamid)
            }
        }
    }
    
    private func updateTeamResults(teamId: Int, won: Bool) {
        var results = lastThreeResults[teamId] ?? []
        results.insert(won, at: 0)
        if results.count > 3 {
            results = Array(results.prefix(3))
        }
        lastThreeResults[teamId] = results
    }
    
    private func updatePreviousRoundResults() {
        for game in games {
            if game.complete == 100 {
                previousRoundResults[game.hteamid] = game.hteamid == game.winnerteamid
                previousRoundResults[game.ateamid] = game.ateamid == game.winnerteamid
            }
        }
    }
}


struct GameResponse: Codable {
    let games: [Game]
}

struct Game: Codable {
    let timestr: String?
    let winner: String?
    let isGrandFinal: Int
    let ascore: Int?
    let unixtime: Int
    let roundname: String
    let hscore: Int?
    let venue: String
    let winnerteamid: Int?
    let updated: String
    let hbehinds: Int?
    let year: Int
    let isFinal: Int
    let agoals: Int?
    let localtime: String
    let hteam: String
    let hteamid: Int
    let hgoals: Int?
    let complete: Int
    let round: Int
    let date: String
    let ateam: String
    let ateamid: Int
    let abehinds: Int?
    let tz: String
    let id: Int
    
    // Custom CodingKeys to match JSON keys with properties
    enum CodingKeys: String, CodingKey {
        case timestr, winner, ascore, unixtime, roundname, hscore, venue, winnerteamid, updated, hbehinds, year, agoals, localtime, hteam, hteamid, hgoals, complete, round, date, ateam, ateamid, abehinds, tz, id
        case isGrandFinal = "is_grand_final"
        case isFinal = "is_final"
    }
}

// Decoding example JSON data
let jsonString = """
{
    "games": [
        {
            "tz": "+10:00",
            "id": 35799,
            "agoals": 16,
            "date": "2024-05-30 19:30:00",
            "unixtime": 1717061400,
            "hteamid": 13,
            "abehinds": 11,
            "hscore": 71,
            "hteam": "Port Adelaide",
            "is_final": 0,
            "hbehinds": 11,
            "ascore": 107,
            "ateam": "Carlton",
            "roundname": "Round 12",
            "complete": 100,
            "round": 12,
            "winner": "Carlton",
            "winnerteamid": 3,
            "timestr": "Full Time",
            "ateamid": 3,
            "updated": "2024-05-30 22:08:51",
            "is_grand_final": 0,
            "venue": "Adelaide Oval",
            "hgoals": 10,
            "year": 2024,
            "localtime": "2024-05-30 19:00:00"
        }
    ]
}
"""

