//
//  foodrinkApp.swift
//  foodrink
//
//  Created by jhon on 4/15/24.
//

import SwiftUI

@main
struct foodrinkApp: App {
    
    @StateObject private var manager: ItemDataManager = ItemDataManager()
        
    var body: some Scene {
        WindowGroup {
            foodListView()
                .environmentObject(manager)
               
        }
    }
}


