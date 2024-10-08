//
//  StationDetailView.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/18.
//

import SwiftUI
import MapKit


enum MapAppOption {
    case googleMaps
    case appleMaps
}

struct StationDetailView: View {
    
//    var station: Station
    var station: Station
    
    private let locationManager = LocationManager()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var region = MKCoordinateRegion()
    
    @State private var userLocation: CLLocationCoordinate2D?
    
    @State private var position: MapCameraPosition = .automatic
    
    @State private var showMapOptions: Bool = false
    
    
    
    var bikeTotalColor: Color {
        let total = Float(station.total ?? 0)
        let ailableRentBikes =  Float(station.availableRentBikes ?? 0)
        
        if ailableRentBikes < (total * 0.2) {
            return .red
        } else if ailableRentBikes < (total * 0.5) {
            return .yellow
        } else {
            return .green
        }
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("位置")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    showMapOptions.toggle()
                }, label: {
                    Map(position: $position, interactionModes: []) {
                        Annotation("U-Bike", coordinate: region.center) {
                            Image(systemName: "bicycle.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.orange500)
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.vertical)
                })
                .confirmationDialog("選擇導航地圖", isPresented: $showMapOptions, titleVisibility: .visible) {
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                        Button("使用 Google Maps") {
                            openSelectedMapApp(.googleMaps)
                        }
                    }
                    Button("使用 Apple Maps") {
                        openSelectedMapApp(.appleMaps)
                    }
                    Button("取消", role: .cancel){}
                }
                
               
                    
                    
                
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Text("YouBike2.0系統更新時間: ")
                        Spacer()
                        Text("\(station.srcUpdateTime ?? "無")")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(.top, 5)
                    .padding(.bottom, 4)
                   
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(height: 1)
                    
                    Text("站點資訊")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.vertical)
                    
                    
                    
                    VStack(spacing: 15) {
                        InfoRow(title: "站點代號", value: "\(station.sno ?? "無")")
                        
                        InfoRow(title: "全部停車格", value: "\(station.total ?? 0)")
                                            
                        
                        HStack {
                            Text("可租車輛")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(station.availableRentBikes ?? 0)")
                                .fontWeight(.semibold)
                                .foregroundStyle(bikeTotalColor)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                }
                        }
                        
                        InfoRow(title: "可還車空位", value: "\(station.availableReturnBikes ?? 0)")
                        
                        InfoRow(title: "資料更新時間", value: "\(station.infoTime ?? "錯誤")")
                        
                    }
                    .foregroundStyle(.white)
                    
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.orange500)
                }
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("\(station.sna ?? "未知")")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }
                    ) {
                        Image(systemName: "bicycle")
                            .foregroundStyle(.o)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                }
            }
            .task {
                setRegion()
                locationManager.checkAuthorization()
                
                do {
                    userLocation = try await locationManager.currentLocation.coordinate
                } catch {
                    print("無法獲取用戶位置：\(error.localizedDescription)")
                }
                
            }
        }
        
        
    }
    
    
    private func setRegion() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: station.latitude ?? 25.02153,
                longitude: station.longitude ?? 121.54124
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        )
        
        position = MapCameraPosition.camera(.init(centerCoordinate: region.center, distance: 150))
        
    }
    
    func openSelectedMapApp(_ mapType: MapAppOption = .appleMaps) {
        guard let userLocation = userLocation else {
            print("用户位置不可用，使用站点位置做爲起點")
            openGoogleMaps(from: region.center, to: region.center)
            return
        }
        
        switch mapType {
        case .googleMaps:
            openGoogleMaps(from: userLocation, to: region.center)
        case .appleMaps:
            openAppleMaps(from: userLocation, to: region.center)
        }
    }
    
    
    func openGoogleMaps(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let urlScheme = "comgooglemaps://"
        
        if UIApplication.shared.canOpenURL(URL(string: urlScheme)!) {
            let urlString = "comgooglemaps://?saddr=\(start.latitude),\(start.longitude)&daddr=\(end.latitude),\(end.longitude)&directionsmode=walking"
            if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                UIApplication.shared.open(url)
            }
        } else {
            // 提示用户安装 Google 地图或使用 Apple 地图
            print("未安装 Google Maps。")
            UIApplication.shared.open(URL(string: "https://apps.apple.com/app/id585027354")!)
        }
    }
    
    func openAppleMaps(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let urlString = "http://maps.apple.com/?saddr=\(start.latitude),\(start.longitude)&daddr=\(end.latitude),\(end.longitude)&dirflg=w"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
}

#Preview {
    StationDetailView(station: Station.testData[0])
//    StationDetailView(station: .constant(Station.testData[0]))
}

struct InfoRow: View {
    let title: String
    let value: String
    
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
