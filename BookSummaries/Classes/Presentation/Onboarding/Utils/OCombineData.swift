//
//  OCombineData.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

struct OCombineData {
    let goal: Int
    let categories: [String]
    let quantity: Int
}

final class OnboardingCombineData {
    private var goal: OGoalButton.Goal?
    private var categories: [OCategoriesCollectionElement]?
    private var quantity: OQuantityButton.Quantity?
    
    func combineData() -> OCombineData? {
        guard
            let goal = goal,
            let categories = categories,
            let quantity = quantity
        else {
            return nil
        }

        return OCombineData(
            goal: goal.code,
            categories: categories.map { $0.title },
            quantity: quantity.code
        )
    }
}

// MARK: OGoalViewDelegate
extension OnboardingCombineData: OGoalViewDelegate {
    func goalViewDidSelected(goal: OGoalButton.Goal) {
        self.goal = goal
    }
}

// MARK: OCategoriesViewDelegate
extension OnboardingCombineData: OCategoriesViewDelegate {
    func categoriesViewDidSelected(elements: [OCategoriesCollectionElement]) {
        self.categories = elements
    }
}

// MARK: OQuantityViewDelegate
extension OnboardingCombineData: OQuantityViewDelegate {
    func quantityViewDidSelected(quantity: OQuantityButton.Quantity) {
        self.quantity = quantity
    }
}
