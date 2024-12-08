// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Certificates} from "../src/Certificate.sol";

contract CounterScript is Script {
    Certificates public certificate;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        //certificate = new Certificates();

        vm.stopBroadcast();
    }
}
