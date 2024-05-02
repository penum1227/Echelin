//
//  foodCreateView.swift
//  tasteable
//
//  Created by jhon on 4/14/24.
//

import SwiftUI
import PhotosUI
import CoreData

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dataManager: ItemDataManager
    @State private var selectedImages: [IdentifiableImage] = []
    @State private var name: String = ""
    @State private var consumptionDate = Date()
    @State private var priority: Int = 3
    @State private var recipe: String = ""
    @State private var experience: String = ""
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                ImageSection
                DetailsSection
                RecipeSection
                ExperienceSection
                SaveButton
            }
            .navigationBarTitle("Add New Food", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private var ImageSection: some View {
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
    
    private var DetailsSection: some View {
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
    
    private var RecipeSection: some View {
        Section(header: Text("Recipe")) {
            TextEditor(text: $recipe).frame(height: 100)
        }
    }
    
    private var ExperienceSection: some View {
        Section(header: Text("Experience")) {
            TextEditor(text: $experience).frame(height: 100)
        }
    }
    
    private var SaveButton: some View {
        Button("Save") {
            addNewFoodItem()
        }
    }
    
    private func addNewFoodItem() {
        dataManager.addFood(
            name: name,
            consumptionDate: consumptionDate,
            priority: Int16(priority),
            recipe: !recipe.isEmpty ? recipe : nil,
            images: selectedImages,
            experience: !experience.isEmpty ? experience : nil
        )
        print(dataManager.foods)
        dismiss()
    }
}







