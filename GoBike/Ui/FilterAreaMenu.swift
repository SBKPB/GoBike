//
//  FilterAreaMenu.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/18.
//

import SwiftUI

struct FilterAreaMenu: View {
    
    let areas: [String] = ["中山區", "中正區", "信義區", "內湖區", "北投區", "南港區", "士林區", "大同區", "大安區", "文山區", "松山區", "臺大公館校區", "萬華區"]
    
    @Binding var seletcedArea: String
    @Binding var showMenu: Bool
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                Button(action: {
                    seletcedArea = ""
                    showMenu = false
                }, label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundStyle(Color.orange500)
                        .font(.title)
                        .padding(.leading)
                })
                .frame(width: 50, height: 50)
                
                Spacer()
                
                Text("選擇行政區")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { showMenu = false }, label: {
                    Image(systemName: "x.circle")
                        .foregroundStyle(Color.orange500)
                        .font(.title)
                        .padding(.trailing)
                })
                .frame(width: 50, height: 50)
                
            }
            
            LazyVGrid(columns: self.columns, spacing: 20) {
                ForEach(areas, id: \.self) { area in
                    Text("\(area)")
                        .frame(width: 80)
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.o)
                        }
                        .foregroundColor(Color.color)
                        .onTapGesture {
                            seletcedArea = area
                            showMenu = false
                        }
                }
            }
            
            
            
        }
    }
}

#Preview {
    FilterAreaMenu(seletcedArea: .constant("中山區"), showMenu: .constant(true))
}




