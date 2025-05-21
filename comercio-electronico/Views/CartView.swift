import SwiftUI

struct CartView: View {
    @ObservedObject private var cartManager = CartManager.shared
    @State private var showingCheckout = false
    
    var body: some View {
        NavigationView {
            Group {
                if cartManager.items.isEmpty {
                    VStack {
                        Image(systemName: "cart")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                            .padding()
                        Text("Tu carrito está vacío")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(Array(cartManager.items.keys), id: \.id) { product in
                                HStack {
                                    AsyncImage(url: URL(string: product.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                    .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(product.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("$\(String(format: "%.2f", product.price))")
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Button(action: {
                                            cartManager.removeFromCart(product: product)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.red)
                                        }
                                        
                                        Text("\(cartManager.items[product, default: 0])")
                                            .font(.headline)
                                            .padding(.horizontal, 8)
                                        
                                        Button(action: {
                                            cartManager.addToCart(product: product)
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .padding(.horizontal)
                            }
                            
                            VStack {
                                HStack {
                                    Text("Total:")
                                        .font(.headline)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", cartManager.totalPrice))")
                                        .font(.headline)
                                }
                                
                                Button(action: {
                                    showingCheckout = true
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Proceder al pago")
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .padding(.top)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Carrito de compras")
            .sheet(isPresented: $showingCheckout) {
                CheckoutView()
            }
        }
    }
}

struct CheckoutView: View {
    @ObservedObject private var cartManager = CartManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var orderComplete = false
    
    var body: some View {
        NavigationView {
            VStack {
                if orderComplete {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.green)
                        
                        Text("¡Compra realizada!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Gracias por tu compra. Tu pedido ha sido procesado correctamente.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Volver a la tienda") {
                            cartManager.clearCart()
                            dismiss()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Form {
                        Section(header: Text("Resumen del pedido")) {
                            ForEach(Array(cartManager.items.keys), id: \.id) { product in
                                HStack {
                                    Text(product.title)
                                        .lineLimit(1)
                                    Spacer()
                                    Text("\(cartManager.items[product, default: 0])x")
                                    Text("$\(String(format: "%.2f", product.price * Double(cartManager.items[product, default: 0])))")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            HStack {
                                Text("Total")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(String(format: "%.2f", cartManager.totalPrice))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Section(header: Text("Información de contacto")) {
                            TextField("Nombre", text: .constant(""))
                            TextField("Correo electrónico", text: .constant(""))
                            TextField("Teléfono", text: .constant(""))
                        }
                        
                        Section(header: Text("Dirección de envío")) {
                            TextField("Dirección", text: .constant(""))
                            TextField("Ciudad", text: .constant(""))
                            TextField("Código postal", text: .constant(""))
                        }
                        
                        Section(header: Text("Método de pago")) {
                            Text("Tarjeta de crédito")
                                .font(.headline)
                            TextField("Número de tarjeta", text: .constant(""))
                            TextField("Fecha de expiración", text: .constant(""))
                            TextField("CVV", text: .constant(""))
                        }
                    }
                    
                    Button(action: {
                        // Simular el procesamiento del pago
                        withAnimation {
                            orderComplete = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Confirmar compra")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Checkout")
            .navigationBarItems(trailing: Button("Cancelar") {
                dismiss()
            })
        }
    }
}