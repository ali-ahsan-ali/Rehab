//
//  Mood.swift
//  Rehab1
//
//  Created by Ali, Ali on 18/9/2023.
//

import Foundation
import SwiftUI

enum EmotionState: String, Codable {
    case good
    case neutral
    case painNoImprovement
    case bad
}

struct Emotion: Codable {
    var state: EmotionState

    var moodColor: Color {
        switch state {
        case .good:
            return Color(hex: "77DD77")
        case .bad:
            return Color(hex: "FF6961")
        case .painNoImprovement:
            return Color(hex: "FAC898")
        case .neutral:
            return Color(hex: "cfcfc4")
        }
    }
}

struct Mood: Codable, Identifiable {
    var id = UUID()
    var emotion: Emotion
    var comment: String = ""
    let date: Date

    init(emotion: Emotion, comment: String = "", date: Date) {
        self.emotion = emotion
        self.comment = comment
        self.date = date
    }
}
