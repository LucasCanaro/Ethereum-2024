## 1 Definition

Nick Szabo's definition
```
a set of promises, specified in digital form, including protocols within which the parties perform on the other promises
```

In Ethereum context
```
immutable computer programs that run deterministically in the context of an Ethereum Virtual Machine as part of the Ethereum network protocol
```

contracts only run if they are called by a transaction.

EOA → transaction → contracts

atomic

contract can be deleted
- SELFDESTRUCT

## 2 Languages

runs on EVM

solidity

solc : converts programs to EVM bytecode

ABI : JSON array of function descriptions

### 2.1 Data Types

|type | description |
|---|---|
|bool |  |
|int, uint| |
|address|  balance, transfer |
|bytes1 ~ bytes32|    |
|bytes, string |  |
|enum | enum NAME {LABEL1, LABEL2, ...} |
|struct | struct NAME {TYPE1 VARIABLE1; ...} |
|mapping|   |
|seconds, minutes, hours, days|  |
|wei, finney, szabo, ether |  wei as a base unit |

### 2.2 Predefined Global Variables and Functions

|종류 | description|
|---|---|
|msg | EOA originated <br> msg.sender <br> msb.value <br> msg.gas <br> msg.data <br> msg.sig |
|address | address.balance <br> address.transfer(amount)  <br> address.send(amount)  <br> address.call (payload) <br> address.callcode(payload) <br> address.delegatecall()|
|tx | tx.gasprice, tx.origin |
|block | block.blockhash <br> block.coinbase <br> block.difficulty <br> block.gaslimit  <br> block.number <br>block.timestamp |

### 2.3 Built-in functions

| functions | description |
|---|---|
|addmod, mulmod|  |
|keccak256, sha256, sha3, ripemod160 | hash functions |
|ecrecover | recovers the address used to sign a message from the signature|
|this| address of the contract account |

### 2.4 Functions

~~~
function FunctionName([parameters]) {public|private|internal|external}
[pure|constant|view|payable] [modifiers] [returns (return types)]
~~~

| element | description |
|---|---|
| public | can be called by other contracts of EOA transactions |
| external | public과 동일하지만, contract 내부에서는 this keyword가 없으면 호출할 수 없음|
| internal | contract 내부에서만 접근할 수 있음 |
|  private | internal과 유사하지만, derived contracts에서는 호출할 수 없음 | 
| pure | stored data를 읽고, 쓰지 않고 결과만 return <br> ``` function getBalance() public view returns (uint) { return balance }```|
| view | state를 변경하지 않음 <br> ```function add(uint a, uint b) public pure returns(uint) { return a+b }```|
| payable | accept incoming payments |

### 2.5 Contract Constructor and selfdestruct

initialize the state of the contract

### 2.6 modifier

```
modifier onlyOwner {
    require (msg.sender === owner)
    _;
}
```


### 2.7 Contract Inheritance

```
contract Child is Parent1, Parent2 {
    ...
}
```

### 2.8 error handling

| 구분 | description|
|---|---|
| assert | evaluate functions  ``` require(this.balalnce >= withdraw_amount, "Insufficient balance for withdrawal) msg.sender.transfer(bithdraw_amount); ``` |
|require | evaluate functions && gate condition <br> ``` require (msg.sender == owner, "Only owner can call this contract")```|
| revert | |
| throw  | |

### 2.9 estimating gas cost

```
var contract = web3.eth.contract(abi).at(address);
var gasEstimate = contract.myAweSomeMethod.estimateGas(arg1, arg2, {from: account});
```

### 2.10 fallback function

default function which is called if the transaction that triggered the contract didn't name any of the declared functions in the contract

```
fallback () external payable {}
receive () external payable {}
```

contract는 하나의 fallback function을 가질 수 있음

일반적으로 ether를 받으면 실행 되는 fallback 함수도 존재, 그래서 public, payable 이 붙음

