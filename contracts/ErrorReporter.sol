// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

contract ComptrollerErrorReporter {
    enum Error {
        NO_ERROR,
        UNAUTHORIZED,
        COMPTROLLER_MISMATCH,
        INSUFFICIENT_SHORTFALL,
        INSUFFICIENT_LIQUIDITY,
        INVALID_CLOSE_FACTOR,
        INVALID_COLLATERAL_FACTOR,
        INVALID_LIQUIDATION_INCENTIVE,
        MARKET_NOT_ENTERED, // no longer possible
        MARKET_NOT_LISTED,
        MARKET_ALREADY_LISTED,
        MATH_ERROR,
        NONZERO_BORROW_BALANCE,
        PRICE_ERROR,
        REJECTION,
        SNAPSHOT_ERROR,
        TOO_MANY_ASSETS,
        TOO_MUCH_REPAY
    }

    enum FailureInfo {
        ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
        ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
        EXIT_MARKET_BALANCE_OWED,
        EXIT_MARKET_REJECTION,
        SET_CLOSE_FACTOR_OWNER_CHECK,
        SET_CLOSE_FACTOR_VALIDATION,
        SET_COLLATERAL_FACTOR_OWNER_CHECK,
        SET_COLLATERAL_FACTOR_NO_EXISTS,
        SET_COLLATERAL_FACTOR_VALIDATION,
        SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
        SET_IMPLEMENTATION_OWNER_CHECK,
        SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
        SET_LIQUIDATION_INCENTIVE_VALIDATION,
        SET_MAX_ASSETS_OWNER_CHECK,
        SET_PENDING_ADMIN_OWNER_CHECK,
        SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
        SET_PRICE_ORACLE_OWNER_CHECK,
        SUPPORT_MARKET_EXISTS,
        SUPPORT_MARKET_OWNER_CHECK,
        SET_PAUSE_GUARDIAN_OWNER_CHECK
    }

    /**
      * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
      **/
    event Failure(uint error, uint info, uint detail);

    /**
      * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
      */
    function fail(Error err, FailureInfo info) internal returns (uint) {
        emit Failure(uint(err), uint(info), 0);

        return uint(err);
    }

    /**
      * @dev use this when reporting an opaque error from an upgradeable collaborator contract
      */
    function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
        emit Failure(uint(err), uint(info), opaqueError);

        return uint(err);
    }
}

contract TokenErrorReporter {
    uint public constant NO_ERROR = 0; // support legacy return codes

    error TransferComptrollerRejection(uint256 errorCode); // 转账被管理员拒绝
    error TransferNotAllowed(); // 不允许转账
    error TransferNotEnough(); // 转账金额不足
    error TransferTooMuch(); // 转账金额过多

    error MintComptrollerRejection(uint256 errorCode); // 铸币被管理员拒绝
    error MintFreshnessCheck(); // 铸币新鲜度检查失败

    error RedeemComptrollerRejection(uint256 errorCode); // 赎回被管理员拒绝
    error RedeemFreshnessCheck(); // 赎回新鲜度检查失败
    error RedeemTransferOutNotPossible(); // 赎回转账不可行

    error BorrowComptrollerRejection(uint256 errorCode); // 借款被管理员拒绝
    error BorrowFreshnessCheck(); // 借款新鲜度检查失败
    error BorrowCashNotAvailable(); // 借款现金不可用

    error RepayBorrowComptrollerRejection(uint256 errorCode); // 还款被管理员拒绝
    error RepayBorrowFreshnessCheck(); // 还款新鲜度检查失败

    error LiquidateComptrollerRejection(uint256 errorCode); // 清算被管理员拒绝
    error LiquidateFreshnessCheck(); // 清算新鲜度检查失败
    error LiquidateCollateralFreshnessCheck(); // 清算抵押品新鲜度检查失败
    error LiquidateAccrueBorrowInterestFailed(uint256 errorCode); // 清算计算借款利息失败
    error LiquidateAccrueCollateralInterestFailed(uint256 errorCode); // 清算计算抵押品利息失败
    error LiquidateLiquidatorIsBorrower(); // 清算者是借款人
    error LiquidateCloseAmountIsZero(); // 清算关闭金额为零
    error LiquidateCloseAmountIsUintMax(); // 清算关闭金额为最大值
    error LiquidateRepayBorrowFreshFailed(uint256 errorCode); // 清算还款新鲜度检查失败

    error LiquidateSeizeComptrollerRejection(uint256 errorCode); // 清算没收被管理员拒绝
    error LiquidateSeizeLiquidatorIsBorrower(); // 清算没收者是借款人

    error AcceptAdminPendingAdminCheck(); // 接受管理员待定管理员检查失败

    error SetComptrollerOwnerCheck(); // 设置管理员所有者检查失败
    error SetPendingAdminOwnerCheck(); // 设置待定管理员所有者检查失败

    error SetReserveFactorAdminCheck(); // 设置储备因子管理员检查失败
    error SetReserveFactorFreshCheck(); // 设置储备因子新鲜度检查失败
    error SetReserveFactorBoundsCheck(); // 设置储备因子边界检查失败

    error AddReservesFactorFreshCheck(uint256 actualAddAmount); // 添加储备因子新鲜度检查失败

    error ReduceReservesAdminCheck(); // 减少储备管理员检查失败
    error ReduceReservesFreshCheck(); // 减少储备新鲜度检查失败
    error ReduceReservesCashNotAvailable(); // 减少储备现金不可用
    error ReduceReservesCashValidation(); // 减少储备现金验证失败

    error SetInterestRateModelOwnerCheck(); // 设置利率模型所有者检查失败
    error SetInterestRateModelFreshCheck(); // 设置利率模型新鲜度检查失败
}
