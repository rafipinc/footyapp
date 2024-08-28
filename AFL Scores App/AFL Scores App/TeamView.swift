//
//  TeamView.swift
//  AFL Scores App
//
//  Created by PINCUS, Rafael on 2/6/2024.
//

//import SwiftUI
//
//struct TeamView: View {
//    let teamName: String
//    let score: Int
//    let goals: Int
//    let behinds: Int
//    let image: Image
//    let alignment: HorizontalAlignment
//    let imagePadding: EdgeInsets
//
//    var body: some View {
//        VStack(alignment: alignment) {
//            Image(uiImage: .add)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 75, height: 75)
//                    .padding(imagePadding)
//                Spacer()
//            VStack(alignment: alignment) {
//                Text(teamName)
//                    .font(.system(size: 25))
//                    .multilineTextAlignment(.leading)
//                    .padding(.bottom, 10)
//                Text("Score: \(score)")
//                Text("Goals \(goals)")
//                Text("Behinds \(behinds)")
//            }
//            .font(Font.subheadline)
//            .padding(.leading, alignment == .leading ? 20 : 0)
//            .padding(.trailing, alignment == .trailing ? 20 : 0)
//        }
//        .frame(alignment: alignment == .leading ? .leading : .trailing)
//    }
//}
