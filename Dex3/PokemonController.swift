//
//  PokemonController.swift
//  Dex3
//
//  Created by Jiang Lin on 5/12/2023.
//

import Foundation
import CoreData

struct PokemonController {
  enum NetworkError: Error{
    case urlError, responseError, dataError
  }
  private let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
  
  private func havePokemon()->Bool{
    let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id in %@", [1,100])
    let context = PersistenceController.shared.container.newBackgroundContext()
    
    do{
      let checkPokemon = try context.fetch(fetchRequest)
      if(checkPokemon.count==2){
        return true
      }
    }catch{
      print("Fetch failed: \(error)")
      return false
    }
    return false
    
    
  }
  
  func fetchAllPokemon() async throws -> [TempPokemonModel]? {
    if(havePokemon()){
      return nil
    }
    var allPokemon: [TempPokemonModel] = []
    let pokemonURL = baseURL.appending(path: "pokemon")
    var urlComponent = URLComponents(url: pokemonURL, resolvingAgainstBaseURL: true)
    let urlQueryItems = URLQueryItem(name: "limit", value: "100")
    urlComponent?.queryItems = [urlQueryItems]
    
    guard let fetchUrl = urlComponent?.url else {
      throw NetworkError.urlError
    }
    
    let (data, response) = try await URLSession.shared.data(from: fetchUrl)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw NetworkError.responseError
    }
    
    guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
      throw NetworkError.dataError
    }
    
    for pokemon in pokedex {
      if let url = pokemon["url"] {
        allPokemon.append(try await fetchPokemon(from: url))
      }
    }
    return allPokemon
  }
  
  private func fetchPokemon(from url: String) async throws -> TempPokemonModel {
    
    let pokemonURL = URL(string: url)!
    let urlComponent = URLComponents(url: pokemonURL, resolvingAgainstBaseURL: false)
    
    guard let fetchUrl = urlComponent?.url else {
      throw NetworkError.urlError
    }
    
    let (data, response) = try await URLSession.shared.data(from: fetchUrl)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw NetworkError.responseError
    }
    
    let pokemon = try JSONDecoder().decode(TempPokemonModel.self, from: data)
    
    print("\(pokemon.id): \(pokemon.name)")
    return pokemon
    
  }
}
