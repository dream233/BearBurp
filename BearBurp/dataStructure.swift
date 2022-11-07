//
//  dataStructure.swift
//  JiarongLiang-Lab4
//
//  Created by 梁家榕 on 10/30/22.
//

import UIKit

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}

struct APIData:Decodable {
    let success: Bool
    let message: [Restaurant]
}

struct foodAPIData:Decodable {
    let success: Bool
    let message: [Food]
}

struct reviewAPIData:Decodable {
    let success: Bool
    let message: [Review]
}

struct Restaurant:Decodable,Encodable{
    let id : Int
    let name : String
    let rating : Float
    let location : String
    let image_url : String
}

struct Food:Decodable{
    let id: Int
    let rid:Int
    let name:String
    let rating:Float
    let price:Float
}

struct Review:Decodable {
    let id: Int
    let uid:Int
    let rid:Int
    let title:String
    let content:String
    let rating:Float
}

struct User:Decodable{
    let id: Int
    let username: String
    let password: String
}

