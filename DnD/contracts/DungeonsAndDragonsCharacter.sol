pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DungeonsAndDragonsCharacter is ERC721URISTORAGE, VRFConsumerBase {
    AggregatorV3Interface internal priceFeed;
    bytes32 internal keyHash;
    bytes32 internal fee;
    address public VRFCoordinator;
    address public LinkToken;

    struct Character {
        int256 strenght;
        uint256 dexterity;
        uint256 constitution;
        uint256 intelligence;
        uint256 wisdom;
        uint256 charisma;
        uint256 experience;
        string name;
    }

    Character[] public characters;

    mapping(bytes32 => string) public requestToCharacterName;
    mapping(bytes32 => address) requestToSender;

    event requestedCharacter(bytes32 indexed requestId);

    constructor(
        address _VRFCoordinator,
        address _LinkToken,
        bytes32 _keyhash,
        address _priceFeed
    )
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("DungeonsAndDragonsCharacter", "DandD")
    {
        VRFCoordinator = _VRFCoordinator;
        priceFeed = AggregatorV3Interface(_priceFeed);
        LinkToken = _LinkToken;
        keyHash = _keyhash;
        fee = 0.1 * 10**18; // 0.1 link
    }

    function requestNewRandomCharacter(
        string memory name 
    ) public return(bytes32){
        require (
            LINK.balanceOf(address(this)) >= fee, "Not enough link, fill the contract with faucet"
        );
        bytes32 requestId = requestRandomness(keyHash, fee);

        requestToCharacterName[requestId] = name;
        requestToSender[requestId] = msg.sender;

        emit requestCharacter(requestId);

        return requestId; 

    }

    function fulfillRandomness(bytes32 requestId, uint256 randomnNumber)
        internal 
        override
    {
        uint256 newId = characters.length;
        uint256 strength  = (getLatestPrice() / 1000000000);
        uint256 dexterity = randomNumber % 100;
        uint256 constitution = uint256(keccak256(abi.encode(randomNumber, 1))) % 100;
        uint256 intelligence = uint256(keccak256(abi.encode(randomNumber, 2))) % 100;
        uint256 wisdom = uint256(keccak256(abi.encode(randomNumber, 3))) % 100;
        uint256 charisma = uint256(keccak256(abi.encode(randomNumber, 4))) % 100;
        uint256 experience = 0;
        
        Character memory character = Character(    
            strength,
            dexterity,
            constitution,
            intelligence,
            wisdom,
            charisma,
            experience,
            requestToCharacterName[requestId];
            characters.push(character); 
            _safeMint(requestToSender[requestId], newId);
        );
    }

    function getNumberOfCharacters() public view returns (uint256) {
        return characters.length; 
    }

    function getLatestPrice() public view returns(int){
        (
            uint80 roundId,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

}
