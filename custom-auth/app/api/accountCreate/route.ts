import { NextResponse } from 'next/server';
import { KeyPair } from '@near-js/crypto';
import { submitTransaction, connect } from '@/utils/meta-transactions';
import { InMemoryKeyStore } from '@near-js/keystores';
import { actionCreators } from "@near-js/transactions";
import BN from "bn.js";

// const { parseSeedPhrase, generateSeedPhrase } = require('near-seed-phrase');
const sha256 = require("js-sha256");
const bs58 = require('bs58');
const { sign } = require('tweetnacl');

export async function POST(req: Request) {
    const body = await req.json();

    /**
     * accountId -- the user's desired acct id, e.g. [bob].near
     * userID -- the unique GoogleAuth id retrieved after signing in
     */
    const { accountId, userID } = body;
    console.log("ACCOUNT ID: " + accountId);
    console.log("USER ID: " + userID);

    /////////////////////////////////////////////////////////////////
    // STEP 1: Take the user ID, hash it and use it as randomness
    var hash = sha256.create();
    hash.update(userID);
    var hex = hash.hex();
    var arr = hash.array();

    var b58str = bs58.encode(arr);
    var b58Arr = new Uint8Array(bs58.decode(b58str));

    /////////////////////////////////////////////////////////////////
    // STEP X: Generate KeyPairs
    const key = sign.keyPair.fromSeed(b58Arr);

    const publicKey = new Uint8Array(key.publicKey);
    const secretKey = new Uint8Array(key.secretKey)

    console.log("PUBLIC KEY: " + publicKey);
    console.log("PRIVATE KEY: " + secretKey);

    var pubKeyStr = "ed25519:" + bs58.encode(publicKey);
    var privKeyStr = "ed25519:" + bs58.encode(secretKey);

    console.log("PUB: " + pubKeyStr);
    console.log("PRIV:" + privKeyStr);

    /////////////////////////////////////////////////////////////////
    // STEP X: Create keystore for relayer
    console.log("SETTING KEYSTORE ....");
    const keyStore = new InMemoryKeyStore();
    // const { seedPhrase, publicKey, secretKey } = generateSeedPhrase()
    
    const marcodotioPk = process.env.MARCODOTIO_PRIVATE_KEY_NEAR_MAINNET as string;

    await keyStore.setKey(
        process.env.NEXT_PUBLIC_NETWORK_ID as string,
        "marcodotio.near",
        KeyPair.fromString(marcodotioPk)
    );

    /////////////////////////////////////////////////////////////////
    // STEP X: Connect to relayer
    console.log("CONNECTING marcodotio.near account ....");
    const signerAccount = await connect(
        "marcodotio.near",
        keyStore,
        process.env.NEXT_PUBLIC_NETWORK_ID as string
    );

    const gas = "200000000000000";
    const deposit = "30000000000000000000000";
    const args: any = {
        "new_account_id": accountId,
        "new_public_key": pubKeyStr
    }

    /////////////////////////////////////////////////////////////////
    // STEP X: Build `create_account` transaction
    console.log("PREPARING FUNCTION CALL ....");
    const action = actionCreators.functionCall(
        "create_account",
        args,
        new BN(gas),
        new BN(deposit)
    );

    /////////////////////////////////////////////////////////////////
    // STEP X: Use relayer to create named account
    console.log("SIGNING DELEGATE ....");
    const deserializeDelegate = await signerAccount.signedDelegate({
        actions: [action],
        blockHeightTtl: 600,
        receiverId: "near", // account naming service contract
    });

    try {
        console.log("SUBMITTING TRANSACTION ....");

        const result = await submitTransaction({
            delegate: deserializeDelegate,
            network: process.env.NEXT_PUBLIC_NETWORK_ID as string,
        });

        console.log("TRANSACTION SUBMITTED ....");

        return NextResponse.json(
            // { privateKey: secretKey, result },
            { privateKey: privKeyStr, result },
            {
                status: 200,
                headers: {
                    'content-type': 'text/plain',
                },
            },
        );

    } catch (error: any) {
        console.log("ERROR:" + error);
        return NextResponse.json(
            { error },
            {
                status: 400,
                headers: {
                    'content-type': 'text/plain',
                },
            },
        );
    }
}