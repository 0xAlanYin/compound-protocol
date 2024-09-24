// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

/**
 * @title Compound's InterestRateModel Interface
 * @author Compound
 */
abstract contract InterestRateModel {
    /// @notice Indicator that this is an InterestRateModel contract (for inspection)
    // 使用一个常量来标识这是一个InterestRateModel合约
    bool public constant isInterestRateModel = true;

    /**
     * @notice Calculates the current borrow interest rate per block
     * @param cash The total amount of cash the market has    市场中的现金总量。这是市场中可用于借款的可用资金。
     * @param borrows The total amount of borrows the market has outstanding    市场中未偿还的借款总量。这是市场中当前所有未偿还的借款总额。
     * @param reserves The total amount of reserves the market has    市场中储备的总量。这是市场中保留的资金，通常用于应对市场波动或其他风险。
     * @return The borrow rate per block (as a percentage, and scaled by 1e18)    借款利率，以每个区块的百分比表示，并按 1e18 缩放。返回值表示每个区块的借款利率。
     */
    // 获取借款利率：注意是区块利率，按照每个区块计算利率
    function getBorrowRate(uint256 cash, uint256 borrows, uint256 reserves) external view virtual returns (uint256);

    /**
     * @notice Calculates the current supply interest rate per block
     * @param cash The total amount of cash the market has    市场中的现金总量。这是市场中可用于借款的可用资金。
     * @param borrows The total amount of borrows the market has outstanding    市场中未偿还的借款总量。这是市场中当前所有未偿还的借款总额。
     * @param reserves The total amount of reserves the market has    市场中储备的总量。这是市场中保留的资金，通常用于应对市场波动或其他风险。
     * @param reserveFactorMantissa The current reserve factor the market has    当前市场储备因子。这是一个百分比，表示市场中保留的资金占市场总资金的比例。
     * @return The supply rate per block (as a percentage, and scaled by 1e18)    存款利率，以每个区块的百分比表示，并按 1e18 缩放。返回值表示每个区块的存款利率。
     */
    // 获取存款利率：注意是区块利率，按照每个区块计算利率
    function getSupplyRate(uint256 cash, uint256 borrows, uint256 reserves, uint256 reserveFactorMantissa)
        external
        view
        virtual
        returns (uint256);
}
