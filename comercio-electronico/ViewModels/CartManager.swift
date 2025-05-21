import Foundation
import SwiftUI

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published var items: [Product: Int] = [:]
    
    var totalItems: Int {
        items.values.reduce(0, +)
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.key.price * Double($1.value) }
    }
    
    func addToCart(product: Product) {
        items[product, default: 0] += 1
    }
    
    func removeFromCart(product: Product) {
        if let quantity = items[product], quantity > 1 {
            items[product] = quantity - 1
        } else {
            items.removeValue(forKey: product)
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}