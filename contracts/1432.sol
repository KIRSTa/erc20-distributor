// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DistributorPro {
    address public immutable owner;
    uint256 public feePercent = 50; // 0.5% по умолчанию
    uint256 public totalFeesCollected;

    event Distributed(address indexed token, uint256 recipients, uint256 totalAmount, uint256 fee);
    event FeesClaimed(address indexed owner, uint256 amount);
    event FeePercentUpdated(uint256 newPercent);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 _feePercent) payable {
        require(_feePercent <= 500, "Max 5%");
        owner = msg.sender;
        feePercent = _feePercent;
    }

    function send(address token, address[] calldata to, uint256[] calldata amounts) 
        external onlyOwner payable 
    {
        require(to.length == amounts.length && to.length <= 200, "Max 200");
        require(to.length > 0, "No recipients");

        uint256 totalSent = 0;
        for (uint256 i = 0; i < to.length; i++) {
            totalSent += amounts[i];
            (bool s,) = token.call(abi.encodeWithSelector(0xa9059cbb, to[i], amounts[i]));
            require(s, "Transfer failed");
        }

        if (feePercent > 0) {
            uint256 fee = (totalSent * feePercent) / 10000;
            require(msg.value >= fee, "Not enough ETH for fee");
            
            totalFeesCollected += fee;

            if (msg.value > fee) {
                payable(msg.sender).transfer(msg.value - fee);
            }

            emit Distributed(token, to.length, totalSent, fee);
        }
    }

    function claimFees() external onlyOwner {
        uint256 amount = totalFeesCollected;
        require(amount > 0, "No fees");
        totalFeesCollected = 0;
        payable(owner).transfer(amount);
        emit FeesClaimed(owner, amount);
    }

    function setFeePercent(uint256 newPercent) external onlyOwner {
        require(newPercent <= 500, "Max 5%");
        feePercent = newPercent;
        emit FeePercentUpdated(newPercent);
    }

    receive() external payable {}
}
