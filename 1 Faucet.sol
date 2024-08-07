/*
 * 프로그램 명 : Faucet
 * Deploy 시 balance에 일정 ether를 입금해야 작동 가능
 * contract를 실행하는 EOA로 요청하는 만큼의 ether를 제공
 * 최대 요청 가능 ether는 0.1 ether = 1_000_000_000_000_000_000 wei * 0.1 = 100_000_000_000_000_000 wei
 */

// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Faucet {

    constructor () payable {
        // 생성자가 payable로 선언되어야 이더를 받을 수 있음
    }

    // 이더 인출 함수
    function withdraw (uint amount) public payable {

        require(amount <= 0.1 ether, "requested amount exceeds limit");
        (bool success, ) = msg.sender.call{value: amount} ("");
        require (success, "Transfer failed");
    }

    // 이더를 받을 때 실행되는 함수
    receive() external payable { }

    // fallback 함수
    fallback() external payable { }

    // 잔액 확인 함수
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}