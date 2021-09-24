import "./App.css";
import { useState } from "react";
import { ethers } from "ethers";
import MultiSig from "./artifacts/contracts/MultiSig.sol/MultiSig.json";
import MaliciousCollaborator from "./artifacts/contracts/MaliciousCollaborator.sol/MaliciousCollaborator.json";

// Update with the contract address logged out to the CLI when it was deployed
const MultiSigAddress = "0x1FFd8025E1eA9E6f0aE27fE748479abB5C8459a9";
const MaliciousCollaboratorAddress = "0x9d4ebC4cf701e64419E3A9924474e81Cb964aB56";

function App() {
  // store greeting in local state
  const [balance, setBalance] = useState();
  const [signerAdd, setSignerAdd] = useState();

  // request access to the user's MetaMask account
  async function requestAccount() {
    await window.ethereum.request({ method: "eth_requestAccounts" });
  }

  // call the smart contract, read the current greeting value
  async function fetchGreeting() {
    if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        MultiSigAddress,
        MultiSig.abi,
        signer
      );
      try {
        const data = await contract.Sign();
        console.log("data: ", data);
      } catch (err) {
        console.log("Error: ", err);
      }
    }
  }

  // call the smart contract, read the current greeting value
  async function fetchBalance() {
    if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      try {
        const data = await provider.getBalance(MaliciousCollaboratorAddress);
        console.log("data: ", data);
        console.log("data: ", data.toString());
      } catch (err) {
        console.log("Error: ", err);
      }
    }
  }

  // call the smart contract, read the current greeting value
  async function addBalance() {
    if (!balance) return;
    if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
          MaliciousCollaboratorAddress,
          MaliciousCollaborator.abi,
          signer
      );
      try {
        const data = await contract.addBalance();
        console.log("data: ", data);
      } catch (err) {
        console.log("Error: ", err);
      }
    }
  }

  // call the smart contract, read the current greeting value
  async function collaboratorSign() {
    if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
          MaliciousCollaboratorAddress,
          MaliciousCollaborator.abi,
          signer
      );
      try {
        const data = await contract.signSign(MultiSigAddress);
        console.log("data: ", data);
      } catch (err) {
        console.log("Error: ", err);
      }
    }
  }

  // call the smart contract, send an update
  async function setGreeting() {
    if (!signerAdd) return;
    if (typeof window.ethereum !== "undefined") {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        MultiSigAddress,
        MultiSig.abi,
        signer
      );
      const transaction = await contract.AddSigner(signerAdd);
      await transaction.wait();
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchGreeting}>Sign</button>
        <button onClick={setGreeting}>Add Signer</button>
        <input
          onChange={(e) => setSignerAdd(e.target.value)}
          placeholder="Signer's Address"
        />

        <button onClick={fetchBalance}>FetchBalance</button>
        <button onClick={collaboratorSign}>CollaboratorSign</button>
        <button onClick={addBalance}>Add Balance</button>
        <input
            onChange={(e) => setBalance(e.target.value)}
            placeholder="balance"
        />
      </header>
    </div>
  );
}

export default App;
