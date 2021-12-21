// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint256 private seed;

    mapping(address => uint256) private waveNumber;
    mapping(uint256 => address) private holders;
    mapping(address => uint256) private lastWaveAt;

    struct Wave{
        address waver;
        string message;
        uint256 timestamp;
    }

    event WaveWithMessage(Wave);

    Wave[] waves;

    constructor() payable {
        console.log("I am a super smart contract");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        require(
            lastWaveAt[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );

        lastWaveAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        holders[totalWaves] = msg.sender;
        waveNumber[msg.sender] += 1;

        Wave memory _wave = Wave(msg.sender, _message, block.timestamp);
        waves.push(_wave);

        seed = (block.timestamp + block.difficulty) % 100;
        console.log("Random # generated: %d", seed);

        if(seed <= 50){
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.00001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit WaveWithMessage(_wave);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have a total of %s waves done!", totalWaves);
        // for (uint256 i = 1; i <= totalWaves; i++) {
        //     console.log(
        //         "The address %s has %s waves!",
        //         holders[i],
        //         waveNumber[holders[i]]
        //     );
        // }
        return totalWaves;
    }

    function getAllWaves()public view returns (Wave[] memory) {
        return waves;
    }
}
