// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Strings} from "@openzeppelin-contracts/contracts/utils/Strings.sol";
import {Certificates as Certificate} from "./Certificate.sol";

contract NobsaaOpenGovernance {
    struct Member {
        string Identifier;
        uint YearOfRegisteration;
        bool Executive;
        string Bio;
    }

    uint yearOfLaunch;
    mapping (address => Member) community;

    constructor() {
        yearOfLaunch = (block.timestamp / 31557600) + 1970; 
    }

    /**
     * This entrypoint creates a new instance of a cerificate that can be issued by the community as NFTS.
     *    This instance is an nft contract that manages the issuing of awards/certificate.
     *    @notice it take the msg.sender as the issuing authority for the nfts 
     *    @param name is the name of the nft certificate
     *    @param symbol is the symbol of the certificate
     *    @return certificateAddr the address of the newly created contract
     */
    function createCertificate(string memory name, string memory symbol) external returns (address certificateAddr) {
        Certificate certificate = new Certificate(name, symbol, msg.sender);
        certificateAddr = address(certificate);
    }

    function createOffChainProposal(string memory proposal, uint32 threshold) public {}

    // 
    function voteOffChainProposal(string memory proposal) public {
        (proposal);
        uint currentYear = (block.timestamp / 31557600) + 1970; 
    }

    function cancelOffChainProposal(string memory proposal) public {}

    function registerMember(address who) external {}

    /**
     * @dev checks to make sure that the member exists in the community
     * @param who the address of the member
     * @param duration the number of years being renewed
     */
    function renewMembership(address who, uint16 duration) external {}

    
}
