import Foundation
import StoreKit
import JieqiCore

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var product: Product?
    @Published private(set) var isUnlocked = false
    @Published private(set) var message = "本地测试商品 \(PremiumTheme.productID)，非消耗型，标价 \(PremiumTheme.priceCNY) 元。正式上架前不会扣款。"

    private var didStart = false

    /// 打开「关于」时再读商品。单元测试启动应用时停在首页，不会去连 StoreKit。
    func startIfNeeded() {
        guard !didStart else { return }
        didStart = true
        Task { await reload() }
        Task { await observeTransactions() }
    }

    func reload() async {
        do {
            let products = try await Product.products(for: [PremiumTheme.productID])
            product = products.first
            if let product {
                message = "\(product.displayName) · \(product.displayPrice)。这是本地 StoreKit 测试配置，不是已经上架的商品。"
            }
            await refreshEntitlements()
        } catch {
            product = nil
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                guard case .verified(let transaction) = verification else { return }
                await transaction.finish()
                await refreshEntitlements()
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            message = "这次购买没有完成。"
        }
    }

    private func refreshEntitlements() async {
        var unlocked = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == PremiumTheme.productID && transaction.revocationDate == nil {
                unlocked = true
            }
        }
        isUnlocked = unlocked
    }

    private func observeTransactions() async {
        for await update in Transaction.updates {
            guard case .verified(let transaction) = update else { continue }
            await transaction.finish()
            await refreshEntitlements()
        }
    }
}
