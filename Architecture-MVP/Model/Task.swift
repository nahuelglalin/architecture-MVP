//
//  Task.swift
//  Architecture-MVP
//
//  Created by Nahuel Lalin on 15/12/2023.
//

import Foundation

struct Task {
    let id: UUID = UUID()
    let text: String
    var isFavorite: Bool
}
