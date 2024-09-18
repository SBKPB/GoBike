//
//  ContentView.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/14.
//

import SwiftUI


struct SectionHeaderView: View {
    let sarea: String
    
    var body: some View {
        HStack {
            Text("\(sarea)")
                .font(.title)
        }
        .ignoresSafeArea()
    }
}

struct StationList: View {
    
    @State private var stationStore: StationStore = StationStore(httpClient: HTTPClient())
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State private var searchText: String = ""
    
    @State private var showFilerAreaMenu: Bool = false
    
    @State private var selectedStation: Station?
    
    var body: some View {
        NavigationStack {
            List(stationStore.stations.keys.sorted(), id: \.self) { sarea in
                Section(header: SectionHeaderView(sarea: sarea)) {
                    ForEach(stationStore.stations[sarea] ?? []) { station in
                        ZStack {
                            NavigationLink(destination: StationDetailView(station: station)) {}
                                .opacity(0)
                            StationRow(station: station)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .onChange(of: searchText) {
                Task {
                    do {
                        try await stationStore.getStations(filter: searchText)
                    } catch {
                        print(error)
                    }
                }
            }
            .task {
                do {
                    try await stationStore.getStations()
                } catch {
                    print(error)
                }
            }
            .onReceive(timer) { _ in
                Task {
                    do {
                        try await stationStore.getStations(filter: searchText)
                    } catch {
                        print(error)
                    }
                }
            }
            .navigationTitle("UBike站點")
            .toolbar {
                Button("搜尋", systemImage: "magnifyingglass") { showFilerAreaMenu.toggle() }
            }

            
        }
        
        .sheet(isPresented:  $showFilerAreaMenu) {
            FilterAreaMenu(seletcedArea: $searchText, showMenu: $showFilerAreaMenu)
                .presentationDetents([.medium])
                .padding(.vertical)
        }
        
    }
}

#Preview {
    StationList()
}

