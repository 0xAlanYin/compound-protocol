// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "./InterestRateModel.sol";

/**
 * @title Compound's WhitePaperInterestRateModel Contract
 * @author Compound
 * @notice The parameterized model described in section 2.4 of the original Compound Protocol whitepaper
 */
// 直线型的利率模型
// 借款利率的，其计算公式为：y = k*x + b。 y 即 y 轴的值，即借款利率值，x 即 x 轴的值，表示资金使用率，k 为斜率，b 则是 x 为 0 时的起点值
contract WhitePaperInterestRateModel is InterestRateModel {
    event NewInterestParams(uint256 baseRatePerBlock, uint256 multiplierPerBlock);

    uint256 private constant BASE = 1e18;

    /**
     * @notice The approximate number of blocks per year that is assumed by the interest rate model
     */
    // 常表示在利率模型中假设的一年内的区块数量。在以太坊网络中，假设每个区块的生成时间大约为 15 秒，因此一年内的区块数量大约为 365 * 24 * 60 * 60 / 15 = 2102400。
    uint256 public constant blocksPerYear = 2102400;

    /**
     * @notice The multiplier of utilization rate that gives the slope of the interest rate
     */
    // 区块斜率
    uint256 public multiplierPerBlock;

    /**
     * @notice The base interest rate which is the y-intercept when utilization rate is 0
     */
    // 区块级别的基准利率
    uint256 public baseRatePerBlock;

    /**
     * @notice Construct an interest rate model
     * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by BASE) 基础年利率
     * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by BASE) 斜率 k 值
     */
    constructor(uint256 baseRatePerYear, uint256 multiplierPerYear) public {
        baseRatePerBlock = baseRatePerYear / blocksPerYear;
        multiplierPerBlock = multiplierPerYear / blocksPerYear;

        emit NewInterestParams(baseRatePerBlock, multiplierPerBlock);
    }

    /**
     * @notice Calculates the utilization rate of the market: `borrows / (cash + borrows - reserves)`
     * @param cash The amount of cash in the market
     * @param borrows The amount of borrows in the market
     * @param reserves The amount of reserves in the market (currently unused)
     * @return The utilization rate as a mantissa between [0, BASE]
     */
    // 计算资金利用率 `borrows / (cash + borrows - reserves)`
    function utilizationRate(uint256 cash, uint256 borrows, uint256 reserves) public pure returns (uint256) {
        // Utilization rate is 0 when there are no borrows
        if (borrows == 0) {
            return 0;
        }

        return borrows * BASE / (cash + borrows - reserves);
    }

    /**
     * @notice Calculates the current borrow rate per block, with the error code expected by the market
     * @param cash The amount of cash in the market
     * @param borrows The amount of borrows in the market
     * @param reserves The amount of reserves in the market
     * @return The borrow rate percentage per block as a mantissa (scaled by BASE)
     */
    function getBorrowRate(uint256 cash, uint256 borrows, uint256 reserves) public view override returns (uint256) {
        uint256 ur = utilizationRate(cash, borrows, reserves);
        return (ur * multiplierPerBlock / BASE) + baseRatePerBlock; // 借款利率 = 资金利用率 * 区块斜率 + 区块基准利率,即 y = kx + b
    }

    /**
     * @notice Calculates the current supply rate per block
     * @param cash The amount of cash in the market
     * @param borrows The amount of borrows in the market
     * @param reserves The amount of reserves in the market
     * @param reserveFactorMantissa The current reserve factor for the market
     * @return The supply rate percentage per block as a mantissa (scaled by BASE)
     */
    function getSupplyRate(uint256 cash, uint256 borrows, uint256 reserves, uint256 reserveFactorMantissa)
        public
        view
        override
        returns (uint256)
    {
        uint256 oneMinusReserveFactor = BASE - reserveFactorMantissa;
        uint256 borrowRate = getBorrowRate(cash, borrows, reserves);
        uint256 rateToPool = borrowRate * oneMinusReserveFactor / BASE;
        return utilizationRate(cash, borrows, reserves) * rateToPool / BASE;  // 存款利率 = 资金使用率 * 借款利率 *（1 - 储备金率）
       
    }
}
