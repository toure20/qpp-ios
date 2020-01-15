//
//  CartRepository.swift
//  QPP
//
//  Created by Toremurat on 4/29/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol CartRepositoryProtocol {
    weak var output: CartRepositoryOutput? { get set}
    var isValid: Bool { get }
    func setUserName(_ string: String?)
    func setShippingAddress(_ string: String?)
    func setPhoneNumber(_ string: String?)
    func set(cartItems: [Int: PhotoCart])
    func getItems() -> [Int: PhotoCart]
    func addItems(_ cartItem: PhotoCart, at index: Int)
    func makeOrder(user: User, shipping_method: ShippingOption, payment_method: PaymentOption)
    func calculateTotalAmount() -> String
    func clearItems()
    
    var userName: String? { get }
    var shipingAddres: String? { get }
    var phoneNumber: String? { get }
}

protocol CartRepositoryOutput: class {
    func orderDidCreate()
}

class CartRepository: CartRepositoryProtocol {
    
    weak var output: CartRepositoryOutput?
    private var shippingOption: ShippingOption?
    
    var userName: String?
    var shipingAddres: String?
    var phoneNumber: String?
    private var cartItems: [Int: PhotoCart] = [:]
    private var totalAmount: String?
    
    // MARK: - Setters
    func set(cartItems: [Int: PhotoCart]) {
        self.cartItems = cartItems
    }
    
    func addItems(_ cartItem: PhotoCart, at index: Int) {
        cartItems[index] = cartItem
    }
    
    func setUserName(_ string: String?) {
        self.userName = string
    }
    
    func setShippingAddress(_ string: String?) {
        self.shipingAddres = string
    }
    
    func setPhoneNumber(_ string: String?) {
        self.phoneNumber = string
    }
    
    func setTotalAmount(_ string: String?) {
        self.totalAmount = string
    }
    
    func clearItems() {
        self.cartItems.removeAll()
        NotificationCenter.default
            .post(name: NSNotification.Name.init("cartUpdate"), object: nil)
    }
    
    func calculateTotalAmount() -> String {
        let container = cacheContainer.object(forKey: "CachedSizeAmount")
        let amounts = container?.getPrices()
        var totalAmount: Int = 0
        var currency: String = "KZT"
        for item in cartItems {
            let model = amounts?.first(where: { $0.sizeId == item.value.size.id })
            totalAmount += Int(model?.amount ?? 200.0) * item.value.quantity // by default 200 tg
            currency = model?.currency ?? "KZT"
        }
        return "\(totalAmount) \(currency)"
    }
    
    // MARK: - Getters
    func getItems() -> [Int: PhotoCart] {
        return cartItems
    }
    
    var isValid: Bool {
        return userName != nil && shipingAddres != nil && phoneNumber != nil && !cartItems.isEmpty
    }
    
    func makeOrder(user: User, shipping_method: ShippingOption, payment_method: PaymentOption) {
        guard let name = self.userName, let phone = self.phoneNumber, let address = self.shipingAddres else {
            // empty error
            SVProgressHUD.showError(withStatus: "Что-то пошло не так... Проверьте поля Имя/Номер/Адрес")
            return
        }
        if cartItems.isEmpty {
            SVProgressHUD.showError(withStatus: "Что-то пошло не так... Не добавили фотографии")
            return
        }
        let networkContext = OrderNetworkContext(
            token: user.token,
            email: user.email,
            name: name,
            phone: phone,
            city: user.city,
            address: address,
            shipping_method: shipping_method,
            payment_method: payment_method,
            price: totalAmount ?? "0.0",
            photos: cartItems
        )
        APIManager.makeRequest(target: .createOrder(context: networkContext), success: { [weak self] (json) in
            print(json)
            self?.output?.orderDidCreate()
            SVProgressHUD.showSuccess(withStatus: "Заказ успешно создан")
            self?.clearItems()
        }) { json in
            print(json)
            SVProgressHUD.showError(withStatus: json["error"].string ??
            "Ошибка создания заказ. Перейдите в раздел Профиль - Помощь")
        }
    }
}
