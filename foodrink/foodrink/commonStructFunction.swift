//
//  commonStructFunction.swift
//  foodrink
//
//  Created by jhon on 4/18/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct StarRatingView: View {
    @Binding var rating: Int
    var maximumRating = 5
    // 사용자 정의 이미지 사용
    var offImage = Image("Frame 1") // 비활성화 별 이미지
    var onImage = Image("Frame 2")   // 활성화 별 이미지
    
    var offColor = Color.gray
    var onColor = Color.blue
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
    
        HStack(spacing: 4) {
            ForEach(1...maximumRating, id: \.self) { number in
                image(for: number)
                    .resizable()   // 이미지 크기를 조절 가능하게 설정
                    .aspectRatio(contentMode: .fit)  // 내용의 비율을 유지하며 프레임에 맞게 조절
                    .frame(width: 30, height: 30)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}


struct IdentifiableImage: Identifiable {
    let id: UUID
    let uiImage: UIImage

    init(uiImage: UIImage) {
        self.id = UUID()
        self.uiImage = uiImage
    }

    var image: Image {
        Image(uiImage: self.uiImage)
    }
}



struct MultipleImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImages: [IdentifiableImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0  // 선택 제한 없음
        config.filter = .images    // 이미지만 선택 가능

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultipleImagePicker

        init(_ parent: MultipleImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) // 피커 컨트롤러 닫기

            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    guard let self = self else { return }
                    if let image = object as? UIImage {
                        let resizedImage = self.resizeImage(image: image, targetSize: CGSize(width: 800, height: 600))  // 이미지 크기 조정
                        DispatchQueue.main.async {
                            let identifiableImage = IdentifiableImage(uiImage: resizedImage)
                            self.parent.selectedImages.append(identifiableImage)
                        }
                    }
                }
            }
        }
        
        // 이미지 크기 조정 함수
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio  = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            let rect = CGRect(origin: .zero, size: newSize)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
    }
}


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
