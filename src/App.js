import "./App.css";
import { useState } from "react";
import { ethers } from "ethers";
import MultiSig from "./artifacts/contracts/MultiSig.sol/MultiSig.json";

// Update with the contract address logged out to the CLI when it was deployed
const MultiSigAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";

function App() {
  // store greeting in local state
  const [greeting, setGreetingValue] = useState();

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

  // call the smart contract, send an update
  async function setGreeting() {
    if (!greeting) return;
    if (typeof window.ethereum !== "undefined") {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        MultiSigAddress,
        MultiSig.abi,
        signer
      );
      const transaction = await contract.AddSigner(greeting);
      await transaction.wait();
      // fetchGreeting();
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchGreeting}>Sign</button>
        <button onClick={setGreeting}>Add Signer</button>
        <input
          onChange={(e) => setGreetingValue(e.target.value)}
          placeholder="Signer's Address"
        />
      </header>
    </div>
  );
}

export default App;
