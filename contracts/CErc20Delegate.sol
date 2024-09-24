// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "./CErc20.sol";
import "./CTokenInterfaces.sol";

/**
 * @title Compound's CErc20Delegate Contract
 * @notice CTokens which wrap an EIP-20 underlying and are delegated to
 * @author Compound
 */
// CErc20Delegate 合约，继承自 CErc20，实现了 CDelegateInterface 接口
contract CErc20Delegate is CErc20, CDelegateInterface {
    /**
     * @notice Construct an empty delegate
     */
    constructor() {}

    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public virtual override {
        // Shh -- currently unused
        data;

        // Shh -- we don't ever want this hook to be marked pure
        // 这是一个永远不会执行的 if 语句，用于防止编译器将函数标记为 pure。
        if (false) {
            implementation = address(0);
        }

        require(msg.sender == admin, "only the admin may call _becomeImplementation");
    }

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public virtual override {
        // Shh -- we don't ever want this hook to be marked pure
        // 这是一个永远不会执行的 if 语句，用于防止编译器将函数标记为 pure
        if (false) {
            implementation = address(0);
        }

        require(msg.sender == admin, "only the admin may call _resignImplementation");
    }
}
