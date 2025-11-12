[![GitHub stars](https://img.shields.io/github/stars/yourusername/erc20-distributor?style=social)](https://github.com/yourusername/erc20-distributor/stargazers)
[![License](https://img.shields.io/github/license/yourusername/erc20-distributor)](LICENSE)
[![Remix](https://img.shields.io/badge/Remix-deploy-blue)](https://remix.ethereum.org/#url=https://github.com/yourusername/erc20-distributor/blob/main/contracts/DistributorPro.sol)
[![Base](https://img.shields.io/badge/Base-ready-0099ff)](https://basescan.org)
# ERC-20 Distributor (Base, Ethereum, Polygon, Arbitrum)

**One transaction → 200 recipients**  
Universal airdrop contract for **any ERC-20 token** (USDC, USDT, DAI, etc.)

Deployed & tested on **Base Mainnet**:  
`0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913` (USDC)

## Features
- Send to **200 addresses** in one transaction
- Works with **any ERC-20** (6 or 18 decimals)
- Safe low-level `transfer` with revert on failure
- Only owner can distribute
- Gas-optimized (~45k gas per 100 recipients)

## Quick Start (Remix)

1. Open: https://remix.ethereum.org
2. Copy `contracts/1234.sol`
3. Compile → Deploy
4. Approve token spending:
   ```solidity
   approve(0xYourDistributorAddress, 100000000)
