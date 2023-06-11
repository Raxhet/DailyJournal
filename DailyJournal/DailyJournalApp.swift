//
//  DailyJournalApp.swift
//  DailyJournal
//
//  Created by Илья Меркуленко on 08.06.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage

@main
struct DailyJournalApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
    }
}
