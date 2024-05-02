//
//  drinkListView.swift
//  foodrink
//
//  Created by jhon on 4/18/24.
//

import Foundation
import SwiftUI


import SwiftUI

struct drinkListView: View {

    @EnvironmentObject var dataManager: ItemDataManager
    @State private var showingAddDrinkView = false
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .none {
            didSet {
                dataManager.sortItems(by: sortOrder, itemType: "drink")
            }
        }
    
    
    @State private var isMenuExpanded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("DRINK").font(.title).bold()
                    Menu {
                        NavigationLink("Food", destination: foodListView())
                        NavigationLink("Drink", destination: drinkListView())
                        // 다른 링크 추가 가능
                    } label: {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isMenuExpanded ? 180 : 0))
                    }
                    .onTapGesture {
//                        withAnimation {
//                            isMenuExpanded.toggle()
//                        }
                    }
                    
                    
                    Spacer()
                    
                    Button(action: { showingSortOptions = true }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    
                    Button(action: { showingAddDrinkView = true }) {
                        Image(systemName: "plus")
                    }
                    .fullScreenCover(isPresented: $showingAddDrinkView) {
                        AddDrinkView(dataManager: dataManager)
                    }
                }
                .padding()
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(dataManager.drinks, id: \.self) { item in
                            drinkItemView(drinkItem: item)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            if let index = dataManager.drinks.firstIndex(of: item) {
                                                deleteItems(at: IndexSet(integer: index))
                                            }
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOptions) {
                ActionSheet(title: Text("Sort by"), buttons: [
                    .default(Text("Date")) { sortOrder = .date },
                    .default(Text("Priority")) { sortOrder = .priority },
                    .cancel()
                ])
            }
            .navigationBarHidden(true)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        dataManager.deleteDrink(at: offsets)
    }
}

//DrinkDetailView(drinkItem: drinkItem)

struct drinkItemView: View {
    var drinkItem: FoodItems
    
    var body: some View {
        NavigationLink(destination: drinkDetailView(drinkItem: drinkItem, whiskeynumber: drinkItem.whiskyleft)) {
            VStack(spacing: 0) {
                if let imageData = (drinkItem.images?.array as? [ImageContainer])?.first?.content,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 345, height: 250)  // 크기를 조정
                        .clipped()
                        .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:345, height: 250)
                        .clipped()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(drinkItem.name ?? "Unknown Drink")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(drinkItem.consumptionDate ?? Date(), formatter: dateFormatter)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading)
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0..<Int(drinkItem.priority), id: \.self) { _ in
                            Image("Frame 2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.trailing)
                }
                .frame(height: 75)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight]))
            }
            .frame(width: 345)
            .padding(.horizontal)
        }
        .shadow(radius: 3)
    }
}

struct DrinkListView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = ItemDataManager()
        return drinkListView()
            .environmentObject(dataManager)
    }
}
