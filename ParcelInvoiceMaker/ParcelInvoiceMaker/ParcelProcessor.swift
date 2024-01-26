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
    let address: String
    var receiverName: String
    var receiverMobile: String
    let deliveryCost: Int
    private let discount: Discount
    var discountedCost: Int {
        return discount.strategy.applyDiscount(deliveryCost: deliveryCost)
    }

    init(address: String, receiverName: String, receiverMobile: String, deliveryCost: Int, discount: Discount) {
        self.address = address
        self.receiverName = receiverName
        self.receiverMobile = receiverMobile
        self.deliveryCost = deliveryCost
        self.discount = discount
    }
}

struct NoDiscount: DiscountStrategy {
    func applyDiscount(deliveryCost: Int) -> Int {
        return deliveryCost
    }
}

struct VIPDiscount: DiscountStrategy {
    func applyDiscount(deliveryCost: Int) -> Int {
        return deliveryCost / 20
    }
}

struct CouponDiscount: DiscountStrategy {
    func applyDiscount(deliveryCost: Int) -> Int {
        return deliveryCost / 2
    }
}

protocol DiscountStrategy {
    func applyDiscount(deliveryCost: Int) -> Int
}

enum Discount: Int {
    case none = 0, vip, coupon
    var strategy: DiscountStrategy {
        switch self {
        case .none:
            return NoDiscount()
        case .vip:
            return VIPDiscount()
        case .coupon:
            return CouponDiscount()
        }
    }
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
