pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {

	bool private is_locked = false;

	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns(bool) {
		if (msg.value > highestBid && !is_locked) {

			is_locked = true;
			if (!highestBidder.send(highestBid)) {
				msg.sender.send(msg.value);
			}

			highestBidder = msg.sender;
			highestBid = msg.value;

			is_locked = false;
			return true;
		} else {
			msg.sender.send(msg.value);
			return false;
		}
	}

	/* Give people their funds back */
	function () payable {
	    msg.sender.send(msg.value);
	}
}
