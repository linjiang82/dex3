//
//  ViewModel.swift
//  Dex3
//
//  Created by Jiang Lin on 6/12/2023.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
  enum Status {
    case notStarted
    case fetching
    case success
    case failed(error: Error)
  }
  
  @Published private(set) var status: Status = .success
  
  private var controller: PokemonController
  
  init(controller: PokemonController){
    self.controller=controller
    Task{
      await self.getPokedex()
    }
  }
  
  private func getPokedex() async {
    
    self.status = .fetching
    do {
      guard var pokedex = try await self.controller.fetchAllPokemon() else {
        self.status = .success
        return
      }
      pokedex.sort{ $0.id<$1.id }
      for pokemon in pokedex {
        let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
        newPokemon.id = Int16(pokemon.id)
        newPokemon.name = pokemon.name
        newPokemon.types = pokemon.types
        newPokemon.hp = Int16(pokemon.hp)
        newPokemon.defense = Int16(pokemon.defense)
        newPokemon.attack = Int16(pokemon.attack)
        newPokemon.speed = Int16(pokemon.speed)
        newPokemon.specialAttack = Int16(pokemon.specialAttack)
        newPokemon.specialDefense = Int16(pokemon.specialDefense)
        newPokemon.sprite = pokemon.sprite
        newPokemon.shiny = pokemon.shiny
        newPokemon.favourite = false
        do {
          try PersistenceController.shared.container.viewContext.save()
        } catch {
          // Replace this implementation with code to handle the error appropriately.
          // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
      }
      self.status = .success
    }
    catch{
      print(error)
      self.status = .failed(error: error)
    }
  }
}
