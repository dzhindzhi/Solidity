// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyContract {
  enum Mood {Surprise, Sadness, Disgust, Fear, Happiness, Anger}

  Mood public nastroi = Mood.Sadness;

  modifier checkMood(Mood _check) {
    require(_check == nastroi, "error");
    _;
  }
  
  function setMood(Mood _check) public {
    nastroi = _check;
  }

  function setAction(Mood _check) public view checkMood(_check) returns(uint){
    return 1;
  }
} 