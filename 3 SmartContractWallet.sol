/*
 * 프로그램 명 : SmartContractWallet
 * The wallet has one owner
 * to receive funds, to spend funds on any kind of address(EOA, CA)
 * to allow certain people to spend up to a certain amount of owner's funds 
 * to set the owner to a different address by a minimum of 3 out of 5 guardians
 * guardian은 owner를 다른 주소로 바꿀 때, 3/5의 승인을 받아서, owner 교체가 가능하다
 */

 //SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract SampleWallet {

    address payable owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    mapping(address => bool) public guardian;
    address payable nextOwner;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require (msg.sender == owner, "You are not owner, aborting!");
        _;
    }

    function proposeNewOwner(address payable newOwner) public onlyOwner{
        if(nextOwner != newOwner) {
            nextOwner = newOwner;
            guardiansResetCount = 0;
        }

        guardiansResetCount++;

        if(guardiansResetCount >= confirmationsFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAllowance(address _from, uint _amount) public onlyOwner{
        allowance[_from] = _amount;
        isAllowedToSend[_from] = true;
    }

    function denySending(address _from) public onlyOwner{
        isAllowedToSend[_from] = false;
    }

    function transfer(address payable _to, uint _amount, bytes memory payload) public returns (bytes memory) {
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting.");
        if(msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send any transactions, aborting");
            require(allowance[msg.sender] >= _amount, "You are trying to send more than you are allowed to, aborting");
            allowance[msg.sender] -= _amount;

        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(payload);
        require(success, "Transaction failed, aborting");
        return returnData;
    }

    function setGuardian (address _guardian, bool _status) public onlyOwner {
        guardian[_guardian] = _status;
    }

    receive() external payable {}
}