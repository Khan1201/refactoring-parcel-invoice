//
//  ParcelInvoiceMaker - ParcelProcessor.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

// MARK: - 수정 전 코드

//class ParcelInformation {
//    let address: String
//    var receiverName: String
//    var receiverMobile: String
//    let deliveryCost: Int
//    private let discount: Discount
//    var discountedCost: Int {
//        switch discount {
//        case .none:
//            return deliveryCost
//        case .vip:
//            return deliveryCost / 5 * 4
//        case .coupon:
//            return deliveryCost / 2
//        }
//    }
//
//    init(address: String, receiverName: String, receiverMobile: String, deliveryCost: Int, discount: Discount) {
//        self.address = address
//        self.receiverName = receiverName
//        self.receiverMobile = receiverMobile
//        self.deliveryCost = deliveryCost
//        self.discount = discount
//    }
//}
//
//enum Discount: Int {
//    case none = 0, vip, coupon
//}

// MARK: - 수정 후 코드

class ParcelInformation {
    let discountStrategies: [DiscountStrategy]
    let address: String
    var receiverName: String
    var receiverMobile: String
    let deliveryCost: Int
    private let discount: Discount
    var discountedCost: Int {
        return discountStrategies.filter { $0.canDiscount(category: discount) }.first?.applyDiscount(deliveryCost: deliveryCost) ?? 0
    }

    init(discountStrategies: [DiscountStrategy], address: String, receiverName: String, receiverMobile: String, deliveryCost: Int, discount: Discount) throws {
        
        guard discountStrategies.contains(where: {$0.discountCategory == discount}) else { throw NSError() as Error }
        self.discountStrategies = discountStrategies
        
        self.address = address
        self.receiverName = receiverName
        self.receiverMobile = receiverMobile
        self.deliveryCost = deliveryCost
        self.discount = discount
    }
}

struct NoDiscount: DiscountStrategy {
    let discountCategory: Discount = .none
    
    func applyDiscount(deliveryCost: Int) -> Int {
        return deliveryCost
    }
    
    func canDiscount(category: Discount) -> Bool {
        return category == .none
    }
}

struct VIPDiscount: DiscountStrategy {
    let discountCategory: Discount = .vip
    
    func applyDiscount(deliveryCost: Int) -> Int {
        return deliveryCost / DiscountAmount.vip
    }
    
    func canDiscount(category: Discount) -> Bool {
        return category == .vip
    }
}

struct CouponDiscount: DiscountStrategy {
    let discountCategory: Discount = .coupon
    
    func applyDiscount(deliveryCost: Int) -> Int {
        return deliveryCost / DiscountAmount.coupon
    }
    
    func canDiscount(category: Discount) -> Bool {
        return category == .coupon
    }
}

protocol DiscountStrategy {
    var discountCategory: Discount { get }
    func applyDiscount(deliveryCost: Int) -> Int
    func canDiscount(category: Discount) -> Bool
}

enum Discount: Int {
    case none = 0, vip, coupon
}

enum DiscountAmount {
    static let vip: Int = 20
    static let coupon: Int = 2
}

class ParcelOrderProcessor {
    
    // 택배 주문 처리 로직
    func process(parcelInformation: ParcelInformation, onComplete: (ParcelInformation) -> Void) {
        
        // 데이터베이스에 주문 저장
        save(parcelInformation: parcelInformation)
        
        onComplete(parcelInformation)
    }
    
    func save(parcelInformation: ParcelInformation) {
        // 데이터베이스에 주문 정보 저장
        print("발송 정보를 데이터베이스에 저장했습니다.")
    }
}
