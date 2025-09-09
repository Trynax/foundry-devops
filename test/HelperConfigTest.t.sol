// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {HelperConfig} from "../src/HelperConfig.sol";

contract HelperConfigTest is Test {
    HelperConfig public helper;

    function setUp() public {
        helper = new HelperConfig();
    }

    function testActiveNetworkConfig() public {
        (string memory name, uint256 chainId) = helper.activeNetworkConfig();
        assertEq(chainId, 31337);
        assertEq(name, "Anvil Local");
    }

    function testGetSepoliaConfig() public {
        HelperConfig.NetworkConfig memory config = helper.getConfigByChainId(11155111);
        assertEq(config.chainId, 11155111);
        assertEq(config.name, "Sepolia Testnet");
    }

    function testGetMainnetConfig() public {
        HelperConfig.NetworkConfig memory config = helper.getConfigByChainId(1);
        assertEq(config.chainId, 1);
        assertEq(config.name, "Ethereum Mainnet");
    }

    function testConstants() public {
        assertEq(helper.LOCAL_CHAIN_ID(), 31337);
        assertEq(helper.ETH_SEPOLIA_CHAIN_ID(), 11155111);
        assertEq(helper.ETH_MAINNET_CHAIN_ID(), 1);
    }
}
