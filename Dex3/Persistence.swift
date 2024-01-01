//
//  Persistence.swift
//  Dex3
//
//  Created by Jiang Lin on 14/11/2023.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    let samplePokemon = Pokemon(context: viewContext)
    samplePokemon.id=1
    samplePokemon.name="bulbasaur"
    samplePokemon.attack=60
    samplePokemon.hp=50
    samplePokemon.defense=40
    samplePokemon.speed=30
    samplePokemon.specialAttack=100
    samplePokemon.specialDefense=80
    samplePokemon.types=["grass", "poison"]
    samplePokemon.shiny = URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
    samplePokemon.sprite = URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
    samplePokemon.favourite=false
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "Dex3")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
