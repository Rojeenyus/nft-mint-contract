// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import { Base64 } from "./libraries/Base64.sol";

error Mint__NotENoughEthEntered();

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public immutable i_owner;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Eat", "Greet", "Steal", "Grill", "Look", "Spill", "Drink", "Feel", "Smell", "Hear", "Kill", "Touch", "Throw", "Step", "Break", "See"];
    string[] secondWords = ["My", "Mother's", "Father's", "Sister's", "Teacher's", "Classmate's", "Neighbor's", "Crush's", "Baker's", "Dancer's", "Driver's", "Friend's", "Boyfriend's", "Girlfriend's", "Worker's", "Officemate's"];
    string[] thirdWords = ["Buns", "Phone", "Laptop", "Sausage", "Hair", "Nose", "Underarm", "Pocket", "Money", "Veggies", "Bag", "Pee", "Water", "Friend", "Voice", "Neck"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    modifier onlyOwner {
      require(msg.sender == i_owner);
      _;
   }

    constructor() ERC721 ("RandomNFT", "RAND") {
        i_owner = msg.sender;
        console.log("This is my random NFT contract!");
    }

      // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
      // I seed the random generator. More on this in the lesson. 
      uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
      // Squash the # between 0 and the length of the array to avoid going out of bounds.
      rand = rand % firstWords.length;
      return firstWords[rand];
    }

function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

    function makeAnEpicNFT() public payable {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();
    require(
            newItemId <= 49,
            "Fully Minted"
        );

    if (msg.value < 0.001 ether ) {
            revert Mint__NotENoughEthEntered();
        }

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

     // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory combinedWord = string(abi.encodePacked(first, second, third));
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    // console.log("\n--------------------");
    // console.log(finalTokenUri);
    // console.log("--------------------\n");

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);
    // _setTokenURI(newItemId, "ipfs://INSERT_YOUR_CID_HERE")

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function withdraw() public payable onlyOwner{
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Call failed");
  }

  function getTotalNFTsMintedSoFar() public view returns(uint256){
        return _tokenIds.current();
    }
}