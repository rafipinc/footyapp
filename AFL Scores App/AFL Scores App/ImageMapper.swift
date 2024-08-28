//
//  ImageMapper.swift
//  AFL Scores App
//
//  Created by PINCUS, Rafael on 25/5/2024.
//

import Foundation
import SwiftUI

class ImageMapper {
    func getHomeImage(for game: Game?) -> Image? {
        guard let game = game else { return nil }

        switch game.hteamid {
        case 1:
            return Image(.adelaide)
        case 2:
            return Image(.brisbaneLions)
        case 3:
            return Image(.baggers)
        case 4:
            return Image(.pies)
        case 5:
            return Image(.poop)
        case 6:
            return Image(.freo)
        case 7:
            return Image(.geelong)
        case 8:
            return Image(.gcSuns)
        case 9:
            return Image(.gws)
        case 10:
            return Image(.hawks)
        case 11:
            return Image(.melb)
        case 12:
            return Image(.kangas)
        case 13:
            return Image(.power)
        case 14:
            return Image(.richmond)
        case 15:
            return Image(.saints)
        case 16:
            return Image(.swans)
        case 17:
            return Image(.westCoast)
        case 18:
            return Image(.bulldogs)
        default:
            return Image("error")
        }
    }
    
    func getAwayImage(for game: Game?) -> Image? {
        guard let game = game else { return nil }

        switch game.ateamid {
        case 1:
            return Image(.adelaide)
        case 2:
            return Image(.brisbaneLions)
        case 3:
            return Image(.baggers)
        case 4:
            return Image(.pies)
        case 5:
            return Image(.poop)
        case 6:
            return Image(.freo)
        case 7:
            return Image(.geelong)
        case 8:
            return Image(.gcSuns)
        case 9:
            return Image(.gws)
        case 10:
            return Image(.hawks)
        case 11:
            return Image(.melb)
        case 12:
            return Image(.kangas)
        case 13:
            return Image(.power)
        case 14:
            return Image(.richmond)
        case 15:
            return Image(.saints)
        case 16:
            return Image(.swans)
        case 17:
            return Image(.westCoast)
        case 18:
            return Image(.bulldogs)
        default:
            return Image("error")
        }
    }
}
