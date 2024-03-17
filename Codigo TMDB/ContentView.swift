//
//  ContentView.swift
//  Codigo TMDB
//
//  Created by Ibrahim Baisa on 16/03/24.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                MovieListView(viewModel: viewModel,navigationTitle: "Upcoming Movies",isPopular: false)
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Upcoming")
            }
            
            NavigationView {
                MovieListView(viewModel: viewModel,navigationTitle: "Popular Movies",isPopular: true)
            }
            .tabItem {
                Image(systemName: "star")
                Text("Popular")
            }
        }
    }
}
