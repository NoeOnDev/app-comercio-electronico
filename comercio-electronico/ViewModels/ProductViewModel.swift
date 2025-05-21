import Foundation
import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productService = ProductService()
    
    func loadProducts() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedProducts = try await productService.fetchProducts()
                await MainActor.run {
                    self.products = fetchedProducts
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error cargando productos: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}