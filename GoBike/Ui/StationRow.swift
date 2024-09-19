//
//  StationRow.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/18.
//

import SwiftUI

struct StationRow: View {
    var station: Station
    
    
    var rentStateColor: Color {
        let ailableRentBikes =  Float(station.availableRentBikes ?? 0)
        
        if ailableRentBikes < 5  {
            return .red
        } else if ailableRentBikes < 10 {
            return .yellow
        } else {
            return .green
        }
    }
    
    var timeAgo: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let updateTime = formatter.date(from: station.srcUpdateTime!) {
            let now = Date()
            let timeInterval = now.timeIntervalSince(updateTime)
            
            if timeInterval < 60 {
                return "剛剛"
            } else if timeInterval < 3600 {
                let minutes = Int(timeInterval / 60)
                return "\(minutes) 分鐘前"
            } else if timeInterval < 86400 {
                let hours = Int(timeInterval / 3600)
                return "\(hours) 小時前"
            } else {
                let days = Int(timeInterval / 86400)
                return "\(days) 天前"
            }
        } else {
            return "時間錯誤"
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundColor(rentStateColor)
            VStack(alignment: .leading, spacing: 15) {
                Text("\(station.sna ?? "站名錯誤")")
                    .foregroundStyle(.color)
                    .fontWeight(.bold)
                
                Text("\(station.ar ?? "來源資料更新時間")")
                    .foregroundStyle(.color)
                    .opacity(0.8)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                
                Text("\(timeAgo)")
                    .font(.footnote)
                    .foregroundStyle(.orange500)
                
                HStack {
                    Text("租")
                        .foregroundStyle(.o)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.o)
                        .frame(width: 25, height: 25)
                        .overlay {
                            Text("\(station.availableRentBikes ?? 0)")
                                .foregroundStyle(.y)
                        }
                    
                }
                
                HStack {
                    Text("還")
                        .foregroundStyle(.orange500)
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.color)
                        .frame(width: 25, height: 25)
                        .overlay {
                            Text("\(station.availableReturnBikes ?? 0)")
                                .foregroundStyle(.y)
                        }
                }
                
            }
            .frame(width: 60)
            
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(radius: 1)
        )
        
        
    }
}


#Preview {
    StationRow(station: Station.testData[0])
        .padding(.horizontal)
}
