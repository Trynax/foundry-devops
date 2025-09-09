// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    // Types
    struct NetworkConfig {
        string name;
        uint256 chainId;
    }

    // Constants
    uint256 public constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;

    //  State Variables
    NetworkConfig public activeNetworkConfig;
    
    // Local network state variables
    NetworkConfig public localNetworkConfig;
    mapping(uint256 => NetworkConfig) public networkConfigs;

    constructor() {
        // Initialize network configurations
        networkConfigs[ETH_MAINNET_CHAIN_ID] = getMainnetEthConfig();
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        
        if (block.chainid == ETH_SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == ETH_MAINNET_CHAIN_ID) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    /**
     * @notice Get the configuration for a specific chain ID
     * @param chainId The chain ID to get configuration for
     * @return NetworkConfig for the specified chain
     */
    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].chainId != 0) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            // Return empty config for unknown chains
            return NetworkConfig({
                name: "",
                chainId: 0
            });
        }
    }

    /**
     * @notice Set a custom configuration for a chain ID
     * @param chainId The chain ID to set configuration for
     * @param networkConfig The configuration to set
     */
    function setConfig(uint256 chainId, NetworkConfig memory networkConfig) public {
        networkConfigs[chainId] = networkConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            name: "Ethereum Mainnet",
            chainId: ETH_MAINNET_CHAIN_ID
        });
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            name: "Sepolia Testnet", 
            chainId: ETH_SEPOLIA_CHAIN_ID
        });
    }    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Check if we already have a local network config
        if (localNetworkConfig.chainId != 0) {
            return localNetworkConfig;
        }

        localNetworkConfig = NetworkConfig({
            name: "Anvil Local",
            chainId: LOCAL_CHAIN_ID
        });

        return localNetworkConfig;
    }
}
