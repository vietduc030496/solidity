# solidity

- **address** : lưu trữ địa chỉ contract
- **mapping (address => uint) public balances;**: khai báo mapping type
- **event Sent(address from, address to, uint amount);**: khai báo sự kiện Sent
- **msg, tx, block**: là các biến global để truy cập blockchain
- **error**: khai báo 1 lỗi và thường sử dụng với **revert**

## Language Description

- **Pragma**: 
  - Version pragma: pragma solidity ^0.5.2;
- **import**: import "filename" as symbolName;

## Structure of a Contract

- Function Modifiers: không thể overloading Function Modifiers
- Event: 
- Error:
- Struct:
- Enum:

## Type

- x**3 == x*x*x
- address
  - address: 
  - address payable: có thể gửi ethe qua
