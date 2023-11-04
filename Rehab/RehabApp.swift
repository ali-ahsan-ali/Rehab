//
//  RehabApp.swift
//  Rehab
//
//  Created by Ali, Ali on 2/10/2023.
//

import SwiftUI

@main
struct RehabApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
