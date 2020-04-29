// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.6.8;

import "./OrderFiller.sol";

/// @title Lender base contract
/// @author Melon Council DAO <security@meloncoucil.io>
/// @notice Base contract for Lending adapters in Melon Funds
abstract contract Lender is OrderFiller {
    function lend(bytes memory _encodedArgs) public {
        __validateLendParams(_encodedArgs);

        (
            address[] memory fillAssets,
            uint256[] memory fillExpectedAmounts,
            address[] memory fillApprovalTargets
        ) = __formatLendFillOrderArgs(_encodedArgs);

        __fillLend(
            _encodedArgs,
            __encodeOrderFillData(fillAssets, fillExpectedAmounts, fillApprovalTargets)
        );
    }

    function redeem(bytes memory _encodedArgs) public {
        __validateRedeemParams(_encodedArgs);

        (
            address[] memory fillAssets,
            uint256[] memory fillExpectedAmounts,
            address[] memory fillApprovalTargets
        ) = __formatRedeemFillOrderArgs(_encodedArgs);

        __fillRedeem(
            _encodedArgs,
            __encodeOrderFillData(fillAssets, fillExpectedAmounts, fillApprovalTargets)
        );
    }

    // INTERNAL FUNCTIONS

    function __fillLend(bytes memory _encodedArgs, bytes memory _fillData) internal virtual;

    function __fillRedeem(bytes memory _encodedArgs, bytes memory _fillData) internal virtual;

    function __formatLendFillOrderArgs(bytes memory _encodedArgs)
        internal
        view
        virtual
        returns (
            address[] memory fillAssets_,
            uint256[] memory fillExpectedAmounts_,
            address[] memory fillApprovalTargets_
        );

    function __formatRedeemFillOrderArgs(bytes memory _encodedArgs)
        internal
        view
        virtual
        returns (
            address[] memory fillAssets_,
            uint256[] memory fillExpectedAmounts_,
            address[] memory fillApprovalTargets_
        );

    function __validateLendParams(bytes memory _encodedArgs) internal view virtual;

    function __validateRedeemParams(bytes memory _encodedArgs) internal view virtual;
}
