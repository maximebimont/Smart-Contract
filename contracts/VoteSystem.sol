// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable(msg.sender){

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    WorkflowStatus public workflowStatus;

    Proposal[] public proposals;
    mapping(address => Voter) public voters;
    uint public winningProposalId;

    constructor() {
        workflowStatus = WorkflowStatus.RegisteringVoters;
    }

    modifier onlyAtStatus(WorkflowStatus _status) {
        require(workflowStatus == _status, "Invalid workflow status");
        _;
    }

    event VoterRegistered(address indexed voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address indexed voter, uint proposalId);

    function startProposalsRegistration() external onlyOwner onlyAtStatus(WorkflowStatus.RegisteringVoters) {
        workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function endProposalsRegistration() external onlyOwner onlyAtStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

    function startVotingSession() external onlyOwner onlyAtStatus(WorkflowStatus.ProposalsRegistrationEnded) {
        workflowStatus = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

    function endVotingSession() external onlyOwner onlyAtStatus(WorkflowStatus.VotingSessionStarted) {
        workflowStatus = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }

    function tallyVotes() external onlyOwner onlyAtStatus(WorkflowStatus.VotingSessionEnded) {
        workflowStatus = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
        uint maxVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }

    function registerVoter(address _voterAddress) external onlyAtStatus(WorkflowStatus.RegisteringVoters) onlyOwner {
        require(!voters[_voterAddress].isRegistered, "Voter is already registered");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
    }

    function registerProposal(string memory _description) external onlyAtStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        proposals.push(Proposal({
            description: _description,
            voteCount: 0
        }));
        emit ProposalRegistered(proposals.length - 1);
    }

    function vote(uint _proposalId) external onlyAtStatus(WorkflowStatus.VotingSessionStarted) {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(_proposalId < proposals.length, "Invalid proposal ID");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;

        emit Voted(msg.sender, _proposalId);
    }

    function getWinner() external view onlyAtStatus(WorkflowStatus.VotesTallied) returns (uint) {
        require(workflowStatus == WorkflowStatus.VotesTallied, "Voting is not tallied yet");
        return winningProposalId;
    }
}