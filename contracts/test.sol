// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleDistributorToken
 * @dev ERC-20 токен с функцией раздачи токенов владельцем (owner).
 * Владелец может свободно отправлять токены любым адресам.
 */
contract SimpleDistributorToken {
    string public name = "Distributor Token";
    string public symbol = "DIST";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /**
     * @dev Стандартная функция ERC-20 transfer
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Стандартная функция ERC-20 approve
     */
    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Стандартная функция ERC-20 transferFrom
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Специальная функция для владельца — раздача токенов любому адресу
     *      (без необходимости иметь allowance)
     */
    function distribute(address to, uint256 value) public onlyOwner returns (bool) {
        require(balanceOf[owner] >= value, "Owner has insufficient balance");
        balanceOf[owner] -= value;
        balanceOf[to] += value;
        emit Transfer(owner, to, value);
        return true;
    }

    /**
     * @dev Массовая раздача токенов (до 200 адресов за один вызов — экономия газа)
     */
    function multiDistribute(address[] calldata recipients, uint256[] calldata amounts) 
        external 
        onlyOwner 
        returns (bool) 
    {
        require(recipients.length == amounts.length, "Arrays length mismatch");
        require(recipients.length <= 200, "Too many recipients");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Zero address");
            require(amounts[i] > 0, "Amount must be > 0");

            balanceOf[owner] -= amounts[i];
            balanceOf[recipients[i]] += amounts[i];
            emit Transfer(owner, recipients[i], amounts[i]);
        }
        return true;
    }

    /**
     * @dev Передача владения контрактом
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Позволяет владельцу сжечь свои токены (опционально)
     */
    function burn(uint256 value) public onlyOwner {
        require(balanceOf[owner] >= value, "Insufficient balance");
        balanceOf[owner] -= value;
        totalSupply -= value;
        emit Transfer(owner, address(0), value);
    }
}
