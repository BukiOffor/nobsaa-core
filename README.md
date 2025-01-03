
# **Nobsaa Open Governance Contract**

The `NobsaaOpenGovernance` contract is a decentralized governance system enabling token-based voting and certificate issuance for a community. It supports member registration, voting on off-chain proposals, and managing memberships.

## **Key Features**
1. **Governance Token**:
   - Each registered member is issued governance tokens that determine their voting power.
   - Token balance + calculated "optimal weight" determines voting eligibility.

2. **NFT Certificate Creation**:
   - Allows the creation of NFT-based certificates managed by the community.

3. **Off-Chain Proposals**:
   - Proposals can be created, voted on, and canceled.
   - Voting requires a minimum token threshold.

4. **Membership Management**:
   - Members can be registered, renewed, or revoked.
   - Membership duration affects governance weight.

---

## **State Variables**
- `owner`: The owner of the contract (deployer).
- `yearOfLaunch`: The year the community was launched.
- `governanceToken`: Instance of the `Token` contract used for governance.
- `community`: Mapping of member addresses to their profile details (`Member` struct).
- `certificates`: Mapping of certificate symbols to their contract addresses.
- `offChainProposals`: Mapping of proposal names to their details (`OffChainProposal` struct).
- `membersCount`: Total number of registered members.
- **Constants**:
  - `WEIGHT`: Token weight assigned per year (1000 * 10^18).

---

## **Structs**
1. **Member**:
   - `Identifier`: Unique identifier for the member.
   - `YearOfRegisteration`: Year of membership registration.
   - `Executive`: Indicates if the member holds an executive role.
   - `Bio`: A short biography of the member.

2. **OffChainProposal**:
   - `Proposer`: Address of the proposal creator.
   - `Proposal`: Description of the proposal.
   - `Threshold`: Minimum token weight required to vote.
   - `YeaVotes`: Count of "yes" votes.
   - `NayVotes`: Count of "no" votes.
   - `DayOfProposal`: Proposal creation timestamp.
   - `DurationInDays`: Validity duration in days.

---

## **Functions**

### **Certificate Management**
- `createCertificate(string name, string symbol) → address`:
  - Creates an NFT certificate contract.
  - Returns the address of the newly created certificate.

---

### **Proposal Management**
- `createOffChainProposal(string proposal, uint32 threshold, uint32 duration)`:
  - Creates a new off-chain proposal with voting parameters.
- `voteOffChainProposal(string proposal, bool vote)`:
  - Casts a vote on a proposal. Requires meeting the token weight threshold.
- `cancelOffChainProposal(string proposal)`:
  - Cancels an existing proposal. Can only be called by the proposer or the owner.

---

### **Membership Management**
- `registerMember(address who, string ident, uint16 year, bool executive, string bio)`:
  - Registers a new community member and mints governance tokens for them.
- `renewMembership(address who, uint16 duration)`:
  - Renews a member's membership and mints additional governance tokens.
- `revokeMembership(address who)`:
  - Revokes a member's membership, burns their governance tokens, and removes them from the community.

---

### **Internal Utilities**
- `calculateOptimalWeight(uint256 registerationYear) → uint256`:
  - Calculates a member's "optimal weight" based on their registration year and the community's launch year.

---


### **Considerations**
- **Access Control**:
  - Functions like `registerMember` and `revokeMembership` are restricted to the owner or specific conditions.
- **Voting Power**:
  - A member’s voting power is the sum of their token balance and calculated weight.

---
