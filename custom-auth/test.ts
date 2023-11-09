import { NextResponse } from 'next/server';
import { KeyPair } from '@near-js/crypto';
// import { createAccount, submitTransaction, connect } from '../../../utils/meta-transactions';
import { InMemoryKeyStore } from '@near-js/keystores';
import { actionCreators } from "@near-js/transactions";
const { parseSeedPhrase, generateSeedPhrase } = require('near-seed-phrase');
const sha256 = require("js-sha256");
import BN from "bn.js";

// We take the user ID, hash it and use it as randomness
var hash = sha256.create();
hash.update("106286931906362609286");
console.log("HEX: " + hash.hex());
hash.array();