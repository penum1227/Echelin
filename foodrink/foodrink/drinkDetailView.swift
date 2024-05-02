import SwiftUI
import Foundation


struct drinkDetailView: View {
    var drinkItem: FoodItems
    var whiskeynumber: Int16

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Horizontal ScrollView for drink images, centered within the VStack
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(drinkItem.imagesArray, id: \.self) { img in
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

                // Date and Name of the Drink, with increased internal spacing and centralized alignment
                HStack {
                    Text(drinkItem.consumptionDateFormatted)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)  // Padding to move the date a bit towards the center
                    Spacer()
                    Text(drinkItem.name ?? "Unknown Drink")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.trailing, 20)  // Padding to move the name a bit towards the center
                }
                .padding(.vertical, 8)  // Adjust vertical padding if needed

                Divider()

                // Star Rating View
                StarRatingView(rating: .constant(Int(drinkItem.priority)))
                    .padding()

                Divider()

                // Whiskey Image centered with smaller size
                let whiskeyImage = whiskeyImages[Int(whiskeynumber)].image
                whiskeyImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 70)
                    .padding(.vertical, 20)

                // Tasting Notes
                if let tastingNote = drinkItem.tastingnote, !tastingNote.isEmpty {
                                    Divider()
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Tasting Notes")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(tastingNote)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal, 20)
                                }

                                // Experience, aligned to the top-left
                                if let experience = drinkItem.experience, !experience.isEmpty {
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
