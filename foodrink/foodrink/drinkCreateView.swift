//
//  drinkCreateView.swift
//  foodrink
//
//  Created by jhon on 4/18/24.
//

import Foundation
import SwiftUI

struct bottleidimage: Identifiable {
    let id: Int
    let image: Image
    let level: Int16
}

let whiskeyImages: [bottleidimage] = [
    bottleidimage(id: 0, image: Image("bottleEmpty"), level: 0),
    bottleidimage(id: 1, image: Image("bottle1"), level: 1),
    bottleidimage(id: 2, image: Image("bottle2"), level: 2),
    bottleidimage(id: 3, image: Image("bottle3"), level: 3),
    bottleidimage(id: 4, image: Image("bottleFull"), level: 5)
]


struct AddDrinkView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImages: [IdentifiableImage] = []
    @ObservedObject var dataManager: ItemDataManager
    @State private var selectedWhiskeyLevel: Int16 = 0
    @State private var name: String = ""
    @State private var consumptionDate = Date()
    @State private var priority: Int = 3
    @State private var tastingNote: String = ""
    @State private var experience: String = ""
    @State private var showImagePicker = false
    
    
    
    var body: some View {
        NavigationView {
            Form {
                ImageSectiondrink
                DetailsSectiondrink
                WhiskeyLevelSection
                TastingNoteSection
                ExperienceSectiondrink
                SaveButton
            }
            .navigationBarTitle("Add New Drink", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private var ImageSectiondrink: some View {
        Section(header: Text("Images")) {
            Button("Select Images") {
                showImagePicker = true
            }
            .sheet(isPresented: $showImagePicker) {
                MultipleImagePicker(selectedImages: $selectedImages)
            }
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages.indices, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                selectedImages[index].image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 200)
                                    .cornerRadius(8)
                                    .clipped()
                                
                                Button(action: {
                                    selectedImages.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .padding(2)
                                        .foregroundColor(.red)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                .padding([.top, .trailing], 5)
                            }
                        }
                    }.frame(height: 210)
                }
            }
        }
    }
    
    private var DetailsSectiondrink: some View {
        Section(header: Text("Food Details")) {
            TextField("Name", text: $name)
            DatePicker("Date", selection: $consumptionDate, displayedComponents: .date)
            HStack {
                Spacer()
                StarRatingView(rating: $priority)
                Spacer()
            }
        }
    }
    private var WhiskeyLevelSection: some View {
            Section(header: Text("Whiskey Level")) {
                HStack {
                    ForEach(whiskeyImages) { whiskeyImage in
                        whiskeyImage.image
                            .resizable()
                            // 이미지 크기를 조절 가능하게 설정
                            .aspectRatio(contentMode: .fit)  // 내용의 비율을 유지하며 프레임에 맞게 조절
                            .frame(width: selectedWhiskeyLevel == whiskeyImage.level ? 75 : 60,
                                   height: selectedWhiskeyLevel == whiskeyImage.level ? 75 : 60)
                            .onTapGesture {
                                withAnimation {
                                    selectedWhiskeyLevel = whiskeyImage.level
                                }
                            }
                    }
                }
            }
        }
    
    private var TastingNoteSection: some View {
        Section(header: Text("Tasting Note")) {
            TextEditor(text: $tastingNote).frame(height: 100)
        }
    }
    private var ExperienceSectiondrink: some View {
        Section(header: Text("Experience")) {
            TextEditor(text: $experience).frame(height: 100)
        }
    }
    
    private func addNewDrinkItem() {
            dataManager.addDrink(
                name: name,
                consumptionDate: consumptionDate,
                priority: Int16(priority),
                whiskyleft: selectedWhiskeyLevel,
                tastingnote: !tastingNote.isEmpty ? tastingNote : nil,
                images: selectedImages,
                experience: !experience.isEmpty ? experience : nil
            )
            dismiss()
        }
        
        private var SaveButton: some View {
            Button("Save") {
                addNewDrinkItem()
                print(dataManager.drinks)
            }
        }
}



