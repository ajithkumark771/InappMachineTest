//
//  ShowModel.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 30/09/21.
//

import Foundation

// MARK: - Show
struct Show: Codable {
    let id: Int
    let url: String?
    let name: String
    let type: String
    let language: String
    let genres: [String]
    let status: String?
    let runtime, averageRuntime: Int?
    let premiered, ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let image: Image
    let summary: String
    let updated: Int

    enum CodingKeys: String, CodingKey {
        case id, url, name, type, language, genres, status, runtime, averageRuntime, premiered, ended, officialSite, schedule, rating, weight, image, summary, updated
    }
}

// MARK: - Image
struct Image: Codable {
    let medium, original: String?
}

// MARK: - Nextepisode
struct Nextepisode: Codable {
    let href: String
}

// MARK: - Network
struct Network: Codable {
    let id: Int
    let name: String
    let country: Country?
}

// MARK: - Country
struct Country: Codable {
    let name: String
    let code: String
    let timezone: String
}


// MARK: - Rating
struct Rating: Codable {
    let average: Double?
}

// MARK: - Schedule
struct Schedule: Codable {
    let time: String
    let days: [String]
}

