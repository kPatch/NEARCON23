import { NextResponse } from 'next/server';
import { KeyPair, KeyPairEd25519 } from '@near-js/crypto';
import { createAccount, submitTransaction, connect } from '../../../utils/meta-transactions';
import { InMemoryKeyStore } from '@near-js/keystores';
import { actionCreators } from "@near-js/transactions";
const { parseSeedPhrase, generateSeedPhrase } = require('near-seed-phrase');
const sha256 = require("js-sha256");
import BN from "bn.js";
const bs58 = require('bs58')
const { sign } = require('tweetnacl');

export async function GET() {
    // const res = await fetch('https://data.mongodb-api.com/...', {
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'API-Key': process.env.DATA_API_KEY,
    //   },
    // })

    var hash = sha256.create();
    hash.update("106286931906362609286");
    var arr = hash.array();
    console.log("ARR LENGTH: " + arr.length);
    var hex = hash.hex();
    console.log("HEX: " + hex);

    var bs58_string = bs58.encode(arr);
    // bs58_string += bs58_string;
    // bs58_string = "ED25519:" + bs58_string;

    console.log("BASE58: " + bs58_string);
    const utf8EncodeText = new TextEncoder();
    const byteArray = utf8EncodeText.encode(bs58_string);

    var b58Arr = new Uint8Array(bs58.decode(bs58_string));
    console.log("b58Arr LENGTH: " + b58Arr.length);


    console.log("byteArray LENGTH: " + byteArray.length);
    var uint8arr = Uint8Array.from(arr);
    console.log("uint8arr LENGTH: " + uint8arr.length);

    // const key = sign.keyPair.fromSeed(byteArray);
    // const key = sign.keyPair.fromSecretKey(b58Arr);
    const key = sign.keyPair.fromSeed(b58Arr);


    // const keyPair = KeyPair.fromString(bs58_string);
    // const keyPair = new KeyPairEd25519(bs58_string);
    // const keyPair = new KeyPairEd25519(arr);

    const publicKey = key.publicKey;
    const privateKey = key.privateKey

    console.log("PUBLIC KEY: " + publicKey);
    console.log("PRIVATE KEY: " + publicKey);

    const data = await Response.json(bs58_string);
   
    return Response.json({ data })
  }