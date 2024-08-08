/*
 * 프로그램 명 : WalletWithSimpleMapping
 * mapping 이용 : 계좌마다 잔액 관리 기능
 * 송금(send), 인출 (withdraw) 기능
 * 
 */
 
 // SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract WalletWithSimpleMapping {

    // mapping
    // mapping(uint => bool) public myMapping;
    // mapping(address => bool) public myAddressMapping;
    
    // function setMyMapping (uint _index) public  {
    //     myMapping[_index] = true;
    // }

    // function setMyAddressMapping () public {
    //     myAddressMapping[msg.sender] = true;
    // }

    // mapping-structure
    // deploy 때 smart contract가 일정 금액을 받기 위하여 생성자를payable로 생성
    constructor() payable {

    }

    mapping (address => uint) public balanceReceived;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function sendMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require (_amount <= balanceReceived[msg.sender], "not enough fund");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);

    }

    function withdrawAllMoney(address payable _to) public {
        uint balanceToSend = balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0;
        _to.transfer(balanceToSend);
    }
}