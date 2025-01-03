// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Strings} from "@openzeppelin-contracts/contracts/utils/Strings.sol";
import {Certificates as Certificate} from "./Certificate.sol";
import {Token} from "./Token.sol";

contract NobsaaOpenGovernance {
    struct Member {
        string Identifier;
        uint16 YearOfRegisteration;
        bool Executive;
        string Bio;
    }
    struct OffChainProposal {
        address Proposer;
        string Proposal;
        uint32 Threshold;
        uint32 YeaVotes;
        uint32 NayVotes;
        uint256 DayOfProposal;
        uint256 DurationInDays;
    }
    uint256 constant WEIGHT = 1000 * 10**18;
    address public owner;
    uint256 immutable yearOfLaunch;
    Token public governanceToken;
    mapping(address => Member) community;
    mapping(string => address) certificates;
    mapping(string => OffChainProposal) offChainProposals;

    uint256 public membersCount;

    constructor() {
        yearOfLaunch = (block.timestamp / 31557600) + 1970;
        governanceToken = new Token();
        owner = msg.sender;

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
        certificates[symbol] = certificateAddr;
    }

    function createOffChainProposal(string memory proposal, uint32 threshold, uint32 duration) public {
        require(offChainProposals[proposal].DayOfProposal == 0, "Proposal already exists");
        offChainProposals[proposal] =
            OffChainProposal(msg.sender, proposal, threshold, 0, 0, block.timestamp, uint256(block.timestamp + (duration * 86400)));
    }

    function voteOffChainProposal(string memory proposal, bool vote) public {
        OffChainProposal storage offChainProposal = offChainProposals[proposal];
        require(offChainProposal.DayOfProposal != 0, "Proposal does not exist");
        require(block.timestamp < offChainProposal.DurationInDays, "Proposal has expired");
        uint16 yearOfRegisteration = community[msg.sender].YearOfRegisteration;
        require(yearOfRegisteration != 0, "Member does not exist");
        uint256 optimalWeight = calculateOptimalWeight(yearOfRegisteration);
        uint256 totalWeight = Token(governanceToken).balanceOf(msg.sender) + optimalWeight;
        require(totalWeight >= offChainProposal.Threshold, "User does not have enough weight to vote");
        if (vote) {
            offChainProposal.YeaVotes++;
        } else {
            offChainProposal.NayVotes++;
        }
    }
   

    function cancelOffChainProposal(string memory proposal) public {
        require(msg.sender == offChainProposals[proposal].Proposer || msg.sender == owner, "Only the proposer can cancel the proposal");
        require(offChainProposals[proposal].DayOfProposal != 0, "Proposal does not exist");
        delete offChainProposals[proposal];
    }

    function registerMember(address who, string memory ident, uint16 year, bool executive, string memory bio)
        external
    {
        require(msg.sender == owner, "Only the owner can register a member");
        require(yearOfLaunch <= year, "Year of registration cannot be before the year of launch");
        require(community[who].YearOfRegisteration == 0, "Member already exists");
        community[who] = Member(ident, year, executive, bio);
        Token(governanceToken).mint(who, WEIGHT);
        membersCount++;
    }

    /**
     * @dev checks to make sure that the member exists in the community
     * @param who the address of the member
     * @param duration the number of years being renewed
     */
    function renewMembership(address who, uint16 duration) external {
        require(community[who].YearOfRegisteration != 0, "Member does not exist");
        uint256 weight = duration * WEIGHT;
        Token(governanceToken).mint(who, weight);
    }

    function revokeMembership(address who) external {
        require(msg.sender == who || msg.sender == owner, "Only the owner or the member can revoke membership");
        require(community[who].YearOfRegisteration != 0, "Member does not exist");
        delete community[who];
        Token(governanceToken).burn(who, Token(governanceToken).balanceOf(who));
        membersCount--;
    }

    // this weight is calculated based on the number of years a user missed since the launch of the community
    // this simulation is added to the token balance of the user and is used to determine the voting power of the user
    // if this simulation > threshold, it means the user has paid its dues to till the voting moment and can participate in the voting
    // also the threshold determines the minimum number of years a user must have been in the community to be able to vote
    function calculateOptimalWeight(uint256 registerationYear) internal view returns (uint256 weightOfUser) {
        uint256 decider = registerationYear - yearOfLaunch;
        weightOfUser = decider * WEIGHT;
    }
}
