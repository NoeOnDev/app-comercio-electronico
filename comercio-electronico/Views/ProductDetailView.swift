import SwiftUI

struct ProductDetailView: View {
    let productId: Int
    @State private var product: Product?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Cargando detalles...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let product = product {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: product.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 300)
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(.bottom, 8)
                            
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(String(format: "%.1f", product.rating.rate)) (\(product.rating.count) reseñas)")
                                .foregroundColor(.gray)
                        }
                        
                        Text("Categoría: \(product.category)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                        
                        Text("Descripción:")
                            .font(.headline)
                        
                        Text(product.description)
                            .font(.body)
                            .padding(.bottom)
                        
                        Button(action: {
                            cartManager.addToCart(product: product)
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "cart.badge.plus")
                                Text("Agregar al carrito")
                                Spacer()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Detalle del Producto")
        .onAppear {
            loadProduct()
        }
    }
    
    private func loadProduct() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let service = ProductService()
                let fetchedProduct = try await service.fetchProduct(id: productId)
                await MainActor.run {
                    self.product = fetchedProduct
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error cargando el producto: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}