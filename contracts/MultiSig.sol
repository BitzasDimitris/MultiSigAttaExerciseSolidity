//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MultiSig {
    address owner;

    address[] signersAccounts;
    mapping(address => bool) signed;

    struct Signer {
        address plp;
        bool signed;
    }
    mapping(address => Signer) public signers;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    receive() external payable{}

    function AddSigner(address newSigner) public onlyOwner {
        signers[newSigner] = Signer(newSigner, false);
        signersAccounts.push(newSigner);
    }

    function Sign() public {
        if(signers[msg.sender].plp == address(0x0))console.log("unknown account");
        require(signers[msg.sender].plp != address(0x0), "Who are you? 403");
        signers[msg.sender].signed = true;
        Action();
    }

    function Action() public {
        bool signedCheck = true;
        if (signersAccounts.length == 0) {
            signedCheck = false;
        }
        for (uint256 i = 0; i < signersAccounts.length; i++) {
            if (signers[signersAccounts[i]].signed != true) {
                signedCheck = false;
            }
        }
        if (signedCheck == false) {
            console.log("Signs are missing");
        } else {
            console.log("Your action here");
            PayDividends();
        }
    }

    function PayDividends() internal{
        uint balance = address(this).balance;
        console.log(signersAccounts.length);
        for (uint256 i = 0; i < signersAccounts.length; i++) {
            console.log(toAsciiString(signers[signersAccounts[i]].plp));
            address payable payableAddress = payable(signers[signersAccounts[i]].plp);
            console.log("payable address created");
            if(address(this).balance >= balance / signersAccounts.length){
                (bool sent, bytes memory data) = payableAddress.call{value: balance / signersAccounts.length}("");
                console.log(sent);
                require(sent, "Failed to send Ether");
                console.log(address(this).balance);
            }
            else{
                console.log("Insufficient funds");
            }
        }
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
