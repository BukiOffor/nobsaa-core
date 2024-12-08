// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Strings} from "@openzeppelin-contracts/contracts/utils/Strings.sol";

// TODO: make this a soul bound token
// - means to disable the transfer function
// - also make the burn function only admin

contract Certificates is ERC721 {
    event Revoke(address indexed who, address indexed revoker, uint256 indexed id);

    error CallerIsNotOwner();

    string constant err = "You are not allowed to transfer Ownership";

    uint256 public currentTokenId;
    address public owner;
    mapping(uint256 => string) tokenURIs;

    constructor(string memory _name, string memory _symbol, address _owner) ERC721(_name, _symbol) {
        owner = _owner;
    }

    /**
     * @notice only the admin of this contract can issue NFTS
     * @param recipient the recipient of the award or certificate
     * @param tokenUri the token uri of the certificate prefarble hosted on ipfs
     */
    function mintTo(address recipient, string memory tokenUri) public returns (uint256) {
        if (msg.sender != owner) {
            revert CallerIsNotOwner();
        }
        uint256 tokenId = ++currentTokenId;
        _safeMint(recipient, tokenId);
        tokenURIs[tokenId] = tokenUri;
        return tokenId;
    }

    /**
     * returns the token uri of our the nft.
     * @param id the id of the NFT being queried
     */
    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        return tokenURIs[id];
    }

    /**
     * This function allows users or the issuing authority to revoke membership
     * @param id the id of the nft
     */
    function burn(uint256 id) external {
        address member = _ownerOf[id];
        if (msg.sender != member || msg.sender != owner) {
            revert CallerIsNotOwner();
        }
        // Ownership check above ensures no underflow because address(0) cannot make a call.
        // so if the msg.sender is the owner of the id, then we are sure a balance exists there.
        unchecked {
            _balanceOf[member]--;
        }
        delete _ownerOf[id];
        delete getApproved[id];
        emit Revoke(owner, msg.sender, id);
    }

    /**
     * @notice Members are not allowed to transfer membership or awards
     * @param from void
     * @param to void
     * @param id void
     * @dev the entrypoint reverts upon execution. the tuple is just to silence unused variable warnings
     */
    function safeTransferFrom(address from, address to, uint256 id) public view virtual override {
        // absolutely no reason for doing this. its just to stop the unused variable warnings
        (from, to, id);
        revert(err);
    }

    /**
     * @notice Members are not allowed to transfer membership or awards
     * @param from void
     * @param to void
     * @param id void
     * @param data void
     * @dev the entrypoint reverts upon execution. the tuple is just to silence unused variable warnings
     */
    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) public virtual override {
        (from, to, id, data);
        revert(err);
    }

    /**
     * @notice Members are not allowed to transfer membership or awards
     * @param from void
     * @param to void
     * @param id void
     * @dev the entrypoint reverts upon execution. the tuple is just to silence unused variable warnings
     */
    function transferFrom(address from, address to, uint256 id) public virtual override {
        (from, to, id);
        revert(err);
    }
}
