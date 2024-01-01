//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Jiang Lin on 11/12/2023.
//

import Foundation
import CoreData

struct SamplePokemon {
  static let samplePokemon = {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
    fetchRequest.fetchLimit = 1
    let result = try! context.fetch(fetchRequest)
    
    return result.first!
  }()
}
