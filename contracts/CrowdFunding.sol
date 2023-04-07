// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowFunding {

    enum ProjectState { open, closed }

    struct Contribution {
        address contributor;
        uint value;
    }

    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        ProjectState state;
        uint funds;
        uint fundraisingGoal;
    }

    Project[] public projects;

    mapping (string => Contribution[]) public contributions;

    event ProjectCreated(
        string projectdId,
        string name,
        string description,
        uint fundraisingGoal
    );

    event ProjectFunded(
        string projectId,
        uint value
    );

    event ProjectStateChanged(
        string id,
        ProjectState state
    );

    modifier isAuthor(uint projectIndex) {
        require(projects[projectIndex].author == msg.sender , "You need to be the project author");
        _;
    }

    modifier isNotAuthor(uint projectIndex) {
        require(projects[projectIndex].author != msg.sender , "As author you can't fund your own project");
        _;
    }

    function createProject(string calldata _id, string calldata _name, string calldata _description, uint _fundraisingGoal) public {
        require(_fundraisingGoal > 0, "fundraising goal must ve greater than 0");
        Project memory project = Project(_id, _name, _description, payable(msg.sender), ProjectState.open, 0, _fundraisingGoal);
        projects.push(project);
        emit ProjectCreated(_id, _name, _description, _fundraisingGoal);
    }
   
    function fundProject(uint _projectIndex) public payable isNotAuthor(_projectIndex) {
        Project memory project = projects[_projectIndex];
        require(project.state != ProjectState.closed, "The project can not receive funds");
        require(msg.value > 0, "Fund value must be greater than 0");
        project.author.transfer(msg.value);
        project.funds += msg.value;
        projects[_projectIndex] = project;

        contributions[project.id].push(Contribution(msg.sender, msg.value));

        emit ProjectFunded(project.id, msg.value);
    }

    function changeProjectState(ProjectState _newState, uint _projectIndex) public isAuthor(_projectIndex) {
        Project memory project = projects[_projectIndex];
        require(project.state != _newState, "New state must be different");
        project.state = _newState;
        projects[_projectIndex] = project;
        emit ProjectStateChanged(project.id, _newState);
    }

}
