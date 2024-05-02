import SwiftUI
import CoreData

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct foodListView: View {
    
    @EnvironmentObject var dataManager: ItemDataManager
    @State private var showingAddFoodView = false
    @State private var showingSortOptions = false
    @State private var sortOrder: SortOrder = .none {
            didSet {
                dataManager.sortItems(by: sortOrder, itemType: "food")
            }
        }
    
    @State private var isMenuExpanded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("FOOD").font(.title).bold()
                    Menu {
                        NavigationLink("Food", destination: foodListView())
                        NavigationLink("Drink", destination: drinkListView())
                        // 다른 링크 추가 가능
                    } label: {
                        VStack {
                            Image(systemName: "chevron.up")
                                .rotationEffect(.degrees(isMenuExpanded ? 180 : 0))
                        }
                        .frame(width: 28, height: 30)
                    }
                    .onTapGesture {
                        withAnimation {
                            print("\(isMenuExpanded)")
                            isMenuExpanded.toggle()
                        }
                    }
                    
                    
                    Spacer()
                    
                    Button(action: { showingSortOptions = true }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    
                    Button(action: { showingAddFoodView = true }) {
                        Image(systemName: "plus")
                    }
                    .fullScreenCover(isPresented: $showingAddFoodView) {
                        AddFoodView(dataManager: dataManager)  // Ensure AddFoodView uses ItemDataManager too
                    }
                }
                .padding()
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(dataManager.foods, id: \.self) { item in
                            FoodItemView(foodItem: item)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            if let index = dataManager.foods.firstIndex(of: item) {
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
        dataManager.deleteFood(at: offsets)
    }
}

struct FoodItemView: View {
    var foodItem: FoodItems
    
    var body: some View {
        NavigationLink(destination: FoodDetailView(foodItem: foodItem)) {
            VStack(spacing: 0) {
                if let imageData = (foodItem.images?.firstObject as? ImageContainer)?.content,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 345, height: 250)
                        .clipped()
                        .clipShape(RoundedCorner(radius: 15, corners: [.topLeft, .topRight]))
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 345, height: 250)
                        .clipped()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(foodItem.name ?? "Unknown")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(foodItem.consumptionDate ?? Date(), formatter: dateFormatter)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading)
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0..<Int(foodItem.priority), id: \.self) { _ in
                            Image("Frame 2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 34)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.trailing)
                }
                .frame(height: 75)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
            }
            .frame(width: 345)
            .padding(.horizontal)
        }
        .shadow(radius: 4)
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = ItemDataManager()
        return foodListView()
            .environmentObject(dataManager)
    }
}


