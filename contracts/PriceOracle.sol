// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "./CToken.sol";

// 价格预言机：计算用户的抵押物价值和债务价值都需要通过价格预言机读取到各种代币的市场价格
abstract contract PriceOracle {
    /// @notice Indicator that this is a PriceOracle contract (for inspection)
    bool public constant isPriceOracle = true;

    /**
     * @notice Get the underlying price of a cToken asset
     * @param cToken The cToken to get the underlying price of
     * @return The underlying asset price mantissa (scaled by 1e18).
     *  Zero means the price is unavailable.
     */
    // 根据 cToken 获取标的资产价格 
    function getUnderlyingPrice(CToken cToken) external view virtual returns (uint256);
}
