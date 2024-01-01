//
//  TempPokemonModel.swift
//  Dex3
//
//  Created by Jiang Lin on 4/12/2023.
//

import Foundation

struct TempPokemonModel: Codable {
  let id: Int
  let name: String
  var hp: Int = 0
  var attack: Int = 0
  var defense: Int = 0
  var specialAttack: Int = 0
  var specialDefense: Int = 0
  var speed: Int = 0
  let sprite: URL
  let shiny: URL
  let types: [String]
  
  enum PokemonKeys: String, CodingKey {
    case id
    case name
    case types
    case sprites
    case stats
    
    enum TypesDictionaryKeys: String, CodingKey {
      case type
      
      enum TypeKeys: String, CodingKey {
        case name
      }
      
    }
    
    enum SpritesKeys: String, CodingKey {
      case sprite = "front_default"
      case shiny = "front_shiny"
    }
    
    enum StatDictioinaryKeys: String, CodingKey {
      case value = "base_stat"
      case stat
      
      enum StatKeys: String, CodingKey {
        case name
      }
    }
    
    
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PokemonKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    
    var decodedTypes: [String] = []
    var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
    while !typesContainer.isAtEnd {
      let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypesDictionaryKeys.self)
      let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypesDictionaryKeys.TypeKeys.self, forKey: .type)
      let type = try typeContainer.decode(String.self, forKey: .name)
      decodedTypes.append(type)
      
    }
    self.types = decodedTypes
    
    var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
    while !statsContainer.isAtEnd {
      let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictioinaryKeys.self)
      let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictioinaryKeys.StatKeys.self, forKey: .stat)
      let name = try statContainer.decode(String.self, forKey: .name)
      switch name {
      case "hp":
        self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
      case "attack":
        self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
      case "defense":
        self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
      case "special-attack":
        self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
      case "special-defense":
        self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
      case "speed":
        self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
      default:
        print("never")
      }
    }
    
    let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpritesKeys.self, forKey: .sprites)
    self.shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    self.sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
    
  }
}
