//
//  comercio_electronicoApp.swift
//  comercio-electronico
//
//  Created by macOs on 21/05/25.
//

import SwiftUI

@main
struct comercio_electronicoApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Productos", systemImage: "list.bullet")
                }
            
            CartView()
                .tabItem {
                    Label("Carrito", systemImage: "cart")
                }
                .badge(cartManager.totalItems > 0 ? cartManager.totalItems : 0)
        }
    }
}
