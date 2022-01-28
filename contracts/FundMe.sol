// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol';

contract FundMe {
    mapping(address => uint256) public addressToAmountFunding;
    address owner;
    address[] funders;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFee = AggregatorV3Interface(address(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e));
        return priceFee.version();
    }

    function getPrice() public view returns (int256) {
        AggregatorV3Interface priceFee = AggregatorV3Interface(address(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e));
        (, int256 answer, , ,) = priceFee.latestRoundData();

        return answer;
    }

    function getConversionRate(int256 ethAmount) public view returns (int256) {
        int256 ethPrice = getPrice();
        int256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;

        return ethAmountInUsd;
    }

    // minimum is $2
    function fund() public payable {
        int256 minimumUSD = 2 * 10 ** 18;

        require(getConversionRate(int256(msg.value)) >= minimumUSD, 'A minimum of $2 is required');
        
        addressToAmountFunding[msg.sender] += msg.value;

        funders.push(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);

        for (uint256 i = 0; i < funders.length; i++) {
            
        }
    }
}