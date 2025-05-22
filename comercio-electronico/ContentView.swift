//
//  ContentView.swift
//  comercio-electronico
//
//  Created by macOs on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Cargando productos...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                        Button("Reintentar") {
                            viewModel.loadProducts()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.products) { product in
                                NavigationLink(destination: ProductDetailView(productId: product.id)) {
                                    ProductRow(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mi Tienda")
            .onAppear {
                viewModel.loadProducts()
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            // Reemplazar AsyncImage con un icono genérico
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "cart")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
}
