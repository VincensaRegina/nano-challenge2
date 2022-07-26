//
//  nano_challenge2App.swift
//  nano-challenge2
//
//  Created by Vincensa Regina on 26/07/22.
//

import SwiftUI

@main
struct nano_challenge2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
