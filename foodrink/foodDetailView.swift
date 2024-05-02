import SwiftUI


struct FoodDetailView: View {
    var foodItem: FoodItems  // FoodItems 객체를 받습니다.

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Horizontal ScrollView for food images, centered within the VStack
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(foodItem.imagesArray, id: \.self) { img in
                            if let imageData = img.content, let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 345, height: 250)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .clipped()
                            }
                        }
                    }
                    .frame(height: 250)
                    .padding(.horizontal, 16)  // Add padding to center the images in the ScrollView
                }

                // Date and Name of the Food, with increased internal spacing and centralized alignment
                HStack {
                    Text(foodItem.consumptionDateFormatted)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)  // Padding to move the date a bit towards the center
                    Spacer()
                    Text(foodItem.name ?? "Unknown Food")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.trailing, 20)  // Padding to move the name a bit towards the center
                }
                .padding(.vertical, 8)  // Adjust vertical padding if needed

                Divider()

                // Star Rating View, simplified for consistency
                StarRatingView(rating: .constant(Int(foodItem.priority)))
                    .padding()
                Divider()
                
                // Recipe, aligned to the top-left
                if let recipe = foodItem.recipe, !recipe.isEmpty {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recipe")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(recipe)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                }

                // Experience, aligned to the top-left
                if let experience = foodItem.experience, !experience.isEmpty {
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Experience")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(experience)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationTitle("")  // 네비게이션 바 타이틀을 비워둡니다.
        .navigationBarTitleDisplayMode(.inline)
    }
}
