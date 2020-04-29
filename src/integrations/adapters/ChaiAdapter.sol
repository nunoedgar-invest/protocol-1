// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.6.8;
pragma experimental ABIEncoderV2;

import "../libs/Lender.sol";
import "../interfaces/IChai.sol";

/// @title ChaiAdapter Contract
/// @author Melon Council DAO <security@meloncoucil.io>
/// @notice Adapter for Chai <https://github.com/dapphub/chai>
contract ChaiAdapter is Lender {
    address immutable public CHAI;
    address immutable public DAI;

    constructor(address _chai, address _dai) public {
        CHAI = _chai;
        DAI = _dai;
    }

    /// @notice Provides a constant string identifier for an adapter
    /// @return An identifier string
    function identifier() external pure override returns (string memory) {
        return "CHAI";
    }

    /// @notice Parses the expected assets to receive from a call on integration 
    /// @param _selector The function selector for the callOnIntegration
    /// @return incomingAssets_ The assets to receive
    function parseIncomingAssets(bytes4 _selector, bytes calldata)
        external
        view
        override
        returns (address[] memory incomingAssets_)
    {
        if (_selector == LEND_SELECTOR) {
            incomingAssets_ = new address[](1);
            incomingAssets_[0] = CHAI;
        }
        else if (_selector == REDEEM_SELECTOR) {
            incomingAssets_ = new address[](1);
            incomingAssets_[0] = DAI;
        }
        else {
            revert("parseIncomingAssets: _selector invalid");
        }
    }

    function __fillLend(bytes memory _encodedArgs, bytes memory _fillData)
        internal
        override
        validateAndFinalizeFilledOrder(_fillData)
    {
        (uint256 daiQuantity,) = __decodeLendArgs(_encodedArgs);

        // Execute Lend on Chai
        IChai(CHAI).join(address(this), daiQuantity);
    }

    function __fillRedeem(bytes memory _encodedArgs, bytes memory _fillData)
        internal
        override
        validateAndFinalizeFilledOrder(_fillData)
    {
        (uint256 chaiQuantity,) = __decodeRedeemArgs(_encodedArgs);

        // Execute Redeem on Chai
        IChai(CHAI).exit(address(this), chaiQuantity);
    }

    function __formatLendFillOrderArgs(bytes memory _encodedArgs)
        internal
        view
        override
        returns (address[] memory, uint256[] memory, address[] memory)
    {
        (
            uint256 daiQuantity,
            uint256 minChaiQuantity
        ) = __decodeLendArgs(_encodedArgs);

        address[] memory fillAssets = new address[](2);
        fillAssets[0] = CHAI; // Receive derivative
        fillAssets[1] = DAI; // Lend asset

        uint256[] memory fillExpectedAmounts = new uint256[](2);
        fillExpectedAmounts[0] = minChaiQuantity; // Receive derivative
        fillExpectedAmounts[1] = daiQuantity; // Lend asset

        address[] memory fillApprovalTargets = new address[](2);
        fillApprovalTargets[0] = address(0); // Fund (Use 0x0)
        fillApprovalTargets[1] = CHAI; // Chai contract

        return (fillAssets, fillExpectedAmounts, fillApprovalTargets);
    }

    function __formatRedeemFillOrderArgs(bytes memory _encodedArgs)
        internal
        view
        override
        returns (address[] memory, uint256[] memory, address[] memory)
    {
        (
            uint256 chaiQuantity,
            uint256 minDaiQuantity
        ) = __decodeRedeemArgs(_encodedArgs);

        address[] memory fillAssets = new address[](2);
        fillAssets[0] = DAI; // Receive asset
        fillAssets[1] = CHAI; // Redeem derivative

        uint256[] memory fillExpectedAmounts = new uint256[](2);
        fillExpectedAmounts[0] = minDaiQuantity; // Receive derivative
        fillExpectedAmounts[1] = chaiQuantity; // Lend asset

        address[] memory fillApprovalTargets = new address[](2);
        fillApprovalTargets[0] = address(0); // Fund (Use 0x0)
        fillApprovalTargets[1] = CHAI; // Chai contract

        return (fillAssets, fillExpectedAmounts, fillApprovalTargets);
    }

    function __validateLendParams(bytes memory _encodedArgs) internal view override {
        (
            uint256 daiQuantity,
            uint256 minChaiQuantity
        ) = __decodeLendArgs(_encodedArgs);
        require(daiQuantity > 0);
        require(minChaiQuantity > 0);
    }

    function __validateRedeemParams(bytes memory _encodedArgs) internal view override {
        (
            uint256 chaiQuantity,
            uint256 minDaiQuantity
        ) = __decodeRedeemArgs(_encodedArgs);
        require(chaiQuantity > 0);
        require(minDaiQuantity > 0);
    }

    // PRIVATE FUNCTIONS

    function __decodeLendArgs(bytes memory _encodedArgs)
        private
        pure
        returns (uint256 daiQuantity_, uint256 minChaiQuantity_)
    {
        return abi.decode(_encodedArgs, (uint256,uint256));
    }

    function __decodeRedeemArgs(bytes memory _encodedArgs)
        private
        pure
        returns (uint256 chaiQuantity_, uint256 minDaiQuantity_)
    {
        return abi.decode(_encodedArgs, (uint256,uint256));
    }
}
