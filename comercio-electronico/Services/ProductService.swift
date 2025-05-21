import Foundation

class ProductService {
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let products = try JSONDecoder().decode([Product].self, from: data)
        return products
    }
    
    func fetchProduct(id: Int) async throws -> Product {
        guard let url = URL(string: "https://fakestoreapi.com/products/\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let product = try JSONDecoder().decode(Product.self, from: data)
        return product
    }
}