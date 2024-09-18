//
//  StationStore.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/14.
//

import Foundation

//@MainActor
//class StationStore: ObservableObject {
//    
//    let httpClient: HTTPClient
//    
//    @Published var stations: [String: [Station]] = [:]
//    
//    @Published private(set) var areas: [String] = []
//
//    private func updateAreas() {
//        areas = stations.keys.sorted()
//    }
//    
//    var stations: [String: [Station]] = [:] {
//        didSet {
//            updateAreas()
//        }
//    }
//    
//    init(httpClient: HTTPClient) {
//        self.httpClient = httpClient
//    }
//    
//    func loadStations() async throws -> [Station] {
//        let resource = Resource(url: Constants.Urls.station, modelType: [Station].self)
//        
//        return try await httpClient.fetch(resource)
//    }
//    
//    
//    func groupedBySarea(stations: [Station], filter: String) -> [String: [Station]] {
//        return Dictionary(grouping: stations, by: { $0.sarea ?? "錯誤" })
//    }
//    
//    
//    func getStations(filter: String = "") async throws {
//        let data = try await loadStations()
//        
//        
//        let groupedBySarea = groupedBySarea(stations: data, filter: filter)
//        
//        
//        if filter.isEmpty {
//            stations = groupedBySarea
//        } else {
//            stations = groupedBySarea.filter { $0.key.contains(filter) }
//        }
//        
//        print("areas: \(areas)")
//        
//    }
//    
//    
//}


import Foundation
import Observation

@Observable
class StationStore {
    
    let httpClient: HTTPClient
    
    var stations: [String: [Station]] = [:] {
        didSet {
            updateAreas()
        }
    }
    
    private(set) var areas: [String] = []
    
    private func updateAreas() {
        areas = stations.keys.sorted()
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadStations() async throws -> [Station] {
        let resource = Resource(url: Constants.Urls.station, modelType: [Station].self)
        return try await httpClient.fetch(resource)
    }
    
    func groupedBySarea(stations: [Station], filter: String) -> [String: [Station]] {
        return Dictionary(grouping: stations, by: { $0.sarea ?? "錯誤" })
    }
    
    func getStations(filter: String = "") async throws {
        let data = try await loadStations()
        let groupedBySarea = groupedBySarea(stations: data, filter: filter)
        
        if filter.isEmpty {
            stations = groupedBySarea
        } else {
            stations = groupedBySarea.filter { $0.key.contains(filter) }
        }
    }
}
