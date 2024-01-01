//
//  ContentView.swift
//  Dex3
//
//  Created by Jiang Lin on 14/11/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
//  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
    animation: .default)
  private var pokedex: FetchedResults<Pokemon>
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
    predicate: NSPredicate(format: "favourite = %d", true),
    animation: .default)
  private var favourites: FetchedResults<Pokemon>
  
  @StateObject private var viewModal: ViewModel = ViewModel(controller: PokemonController())
  
  @State private var showFav:Bool = false
  
  var body: some View {
    
    switch viewModal.status {
    case .success:
      NavigationStack {
        List(showFav ? favourites : pokedex) { pokemon in
          NavigationLink(value: pokemon){
            AsyncImage(url: pokemon.sprite) { image in
              image
                .resizable()
                .scaledToFit()
            } placeholder: {
              ProgressView()
            }
            .frame(width: 100, height: 100)
            Text("\(pokemon.name!.capitalized)")
            Spacer()
            Image(systemName: pokemon.favourite ? "star.fill" : "star")
          }
          .navigationTitle("Pokedex")
          .navigationDestination(for: Pokemon.self, destination: {pokemon in
            PokemonDetail().environmentObject(pokemon)
          })
        }
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              Button{
                showFav.toggle()
              } label: {
                Label("Filter By Favourite", systemImage: showFav ? "star.fill" : "star")
              }
              .font(.title)
              .foregroundStyle(.yellow)
              .padding([.horizontal], 10)
            }
          }
      }
    default:
      ProgressView()
    }
  }
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
