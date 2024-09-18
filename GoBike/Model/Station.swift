//
//  Station.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/14.
//

import Foundation






struct Station: Codable, Identifiable, Hashable {
    
    var id : String { return self.sno ?? UUID().uuidString }
    
    let sno: String?
    let sna: String?
    let sarea: String?
    let mday: String?
    let ar: String?
    let sareaen: String?
    let snaen: String?
    let aren: String?
    let act: String?
    let srcUpdateTime: String?
    let updateTime: String?
    let infoTime: String?
    let infoDate: String?
    let total: Int?
    let availableRentBikes: Int?
    let latitude: Double?
    let longitude: Double?
    let availableReturnBikes: Int?

    enum CodingKeys: String, CodingKey {
        case sno
        case sna
        case sarea
        case mday
        case ar
        case sareaen
        case snaen
        case aren
        case act
        case srcUpdateTime
        case updateTime
        case infoTime
        case infoDate
        case total
        case availableRentBikes = "available_rent_bikes"
        case latitude
        case longitude
        case availableReturnBikes = "available_return_bikes"
    }
    
    
    static var testData: [Station] {
        let jsonData = """
            [
                {
                    "sno": "500101001",
                    "sna": "YouBike2.0_捷運科技大樓站",
                    "sarea": "大安區",
                    "mday": "2024-09-18 10:28:16",
                    "ar": "復興南路二段235號前",
                    "sareaen": "Daan Dist.",
                    "snaen": "YouBike2.0_MRT Technology Bldg. Sta.",
                    "aren": "No.235， Sec. 2， Fuxing S. Rd.",
                    "act": "1",
                    "srcUpdateTime": "2024-09-18 10:35:23",
                    "updateTime": "2024-09-18 10:34:52",
                    "infoTime": "2024-09-18 10:28:16",
                    "infoDate": "2024-09-18",
                    "total": 28,
                    "available_rent_bikes": 0,
                    "latitude": 25.02605,
                    "longitude": 121.5436,
                    "available_return_bikes": 28
                },
                {
                    "sno": "500101002",
                    "sna": "YouBike2.0_復興南路二段273號前",
                    "sarea": "大安區",
                    "mday": "2024-09-18 10:25:16",
                    "ar": "復興南路二段273號西側",
                    "sareaen": "Daan Dist.",
                    "snaen": "YouBike2.0_No.273， Sec. 2， Fuxing S. Rd.",
                    "aren": "No.273， Sec. 2， Fuxing S. Rd. (West)",
                    "act": "1",
                    "srcUpdateTime": "2024-09-18 10:35:23",
                    "updateTime": "2024-09-18 10:34:52",
                    "infoTime": "2024-09-18 10:25:16",
                    "infoDate": "2024-09-18",
                    "total": 21,
                    "available_rent_bikes": 0,
                    "latitude": 25.02565,
                    "longitude": 121.54357,
                    "available_return_bikes": 21
                },
                {
                    "sno": "500101003",
                    "sna": "YouBike2.0_國北教大實小東側門",
                    "sarea": "大安區",
                    "mday": "2024-09-18 10:34:20",
                    "ar": "和平東路二段96巷7號",
                    "sareaen": "Daan Dist.",
                    "snaen": "YouBike2.0_NTUE Experiment Elementary School (East)",
                    "aren": "No. 7， Ln. 96， Sec. 2， Heping E. Rd",
                    "act": "1",
                    "srcUpdateTime": "2024-09-18 10:35:23",
                    "updateTime": "2024-09-18 10:34:52",
                    "infoTime": "2024-09-18 10:34:20",
                    "infoDate": "2024-09-18",
                    "total": 16,
                    "available_rent_bikes": 0,
                    "latitude": 25.02429,
                    "longitude": 121.54124,
                    "available_return_bikes": 16
                }
            ]
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let stations = try? decoder.decode([Station].self, from: jsonData)
        return stations ?? []
    }
}

