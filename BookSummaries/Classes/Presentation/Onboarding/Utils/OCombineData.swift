//
//  OCombineData.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

struct OCombineData {
    let goal: Int
}

final class OnboardingCombineData {
    private var goal: OGoalButton.Goal?
    
    func combineData() -> OCombineData? {
        guard
            let goal = goal
        else {
            return nil
        }

        return OCombineData(goal: goal.code)
    }
}

// MARK: OGoalViewDelegate
extension OnboardingCombineData: OGoalViewDelegate {
    func goalViewDidSelected(goal: OGoalButton.Goal) {
        self.goal = goal
    }
}
