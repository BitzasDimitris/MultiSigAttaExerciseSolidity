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

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function AddSigner(address newSigner) public onlyOwner {
        signers[newSigner] = Signer(newSigner, false);
        signersAccounts.push(newSigner);
    }

    function Sign() public {
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
        }
    }
}
