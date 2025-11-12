// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DistributorPro {
    address public owner = msg.sender;
    modifier onlyOwner() { require(msg.sender == owner); _; }

    function send(address token, address[] calldata to, uint256[] calldata amounts) 
        external onlyOwner 
    {
        require(to.length == amounts.length && to.length <= 200, "Max 200");
        for (uint256 i = 0; i < to.length; i++) {
            (bool s,) = token.call(abi.encodeWithSelector(0xa9059cbb, to[i], amounts[i]));
            require(s, "Transfer failed");
        }
    }
}
