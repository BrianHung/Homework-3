pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {

	/* New data structure, keeps track of refunds owed to ex-highest bidders */
	mapping(address => uint) refunds;

	/* Bid function, shifts to push paradigm
	 * Must return true on successful send and/or bid, bidder
	 * reassignment
	 * Must return false on failure and allow people to
	 * retrieve their funds
	 */
	function bid() payable external returns(bool) {
		address sender = msg.sender;
		uint bidBalance = msg.value;

		if (bidBalance > highestBid) {

		    refunds[highestBidder] = highestBid;

		    highestBidder = sender;
		    highestBid = bidBalance;

		    return true;
		} else {

		    refunds[sender] = bidBalance;
		    return false;
		}
	}

	/* New withdraw function, shifts to push paradigm */
	function withdrawRefund() external returns(bool) {
		address sender = msg.sender;
		uint balance = refunds[sender];

		refunds[sender] = 0;
		if (!sender.send(balance)) {
		    refunds[sender] = balance;
		}
	}

	/* Allow users to check the amount they can withdraw */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}

	/* Give people their funds back */
	function () payable {
		address sender = msg.sender;
	    if (!sender.send(msg.value)) {
	        refunds[sender] = msg.value;
	    }
	}
}
