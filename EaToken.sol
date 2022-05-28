//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;
contract EaToken {
    TokenCreator creator;
    address owner;
    bytes32 name;
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);

    constructor(bytes32 name_) {
        minter = msg.sender;
        creator = TokenCreator(msg.sender);
        name = name_;
    }

    function mint(address reciever, uint amount) public {
        require(msg.sender == minter);
        balances[reciever] += amount;
    }

    function send(address reciever, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient Funds");
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit Sent(msg.sender, reciever, amount);
    }

    function changeName(bytes32 newName) public {
        if (msg.sender == address(creator))
        name = newName; 
    }

    function transfer(address newOwner) public {
        if (msg.sender != owner) return;
        if (creator.transferToken(owner, newOwner))
        owner = newOwner;
    }
}

contract TokenCreator {
    function createToken(bytes32 name)
        public
        returns (EaToken tokenAddress)
    {        
        return new EaToken(name);
    }

    function changeName(EaToken tokenAddress, bytes32 name) public {
        tokenAddress.changeName(name);
    }


    function transferToken(address currentOwner, address newOwner)
        public
        pure
        returns (bool ok)
    {
        return keccak256(abi.encodePacked(currentOwner, newOwner))[0] == 0x7f;
    }
}