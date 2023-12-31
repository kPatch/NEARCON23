import { NextResponse } from 'next/server';
import { KeyPair } from "@near-js/crypto";
import { InMemoryKeyStore } from "@near-js/keystores";
import { actionCreators } from "@near-js/transactions";
import axios from "axios";
import BN from "bn.js";
import { connect, submitTransaction } from "../../../utils/meta-transactions";


export async function POST(req: Request) {
    const body = await req.json();
    const {
        accountId,
        title,
        description,
        // cid, 
        image_uri,
        privateKey,
        receiverNFT
    } = body;

    console.log(
        "ACCOUNT ID: " + accountId + 
        " TITLE: " + title + 
        " DESCRIPTION: " + description + 
        " IMAGE_URI: " + image_uri + 
        " PRIVATE KEY: " + privateKey +
        " RECEIVER NFT: " + receiverNFT);

    const keyStore = new InMemoryKeyStore();

    const keypair = KeyPair.fromString(privateKey)

    var pubKey = keypair.getPublicKey();
    var kpStr = keypair.toString();

    console.log("PUB KEY: " + pubKey);
    console.log("KPStr: " + kpStr);
    
    await keyStore.setKey(
        process.env.NEXT_PUBLIC_NETWORK_ID as string,
        accountId,
        // "marcodotio.near",
        keypair
    );

    console.log(`DEBUG: KEYPAIR - ${keypair}`);
    console.log(`DEBUG: NEXT ID - ${process.env.NEXT_PUBLIC_NETWORK_ID}`);

    const signerAccount = await connect(
        `${accountId}`,
        // "marcodotio.near",
        keyStore,
        `${process.env.NEXT_PUBLIC_NETWORK_ID}`
    );

    console.log(`DEBUG: ACCOUNT ID - ${accountId}`);
    console.log(`DEBUG: CONNECT RESULT - ${signerAccount}`);

    const gas = "300000000000000";
    const deposit = "20000000000000000000000";

    const data = JSON.stringify({
        "name": title,
        "description": description,
        "image": image_uri,
        "image_integrity": "r+xt9t8/MXEvI5fg4JIcb4+iskjgljeb2KWafdaRHoU=",
        "image_mimetype": "image/png",
        "animation_url": "",
        "animation_url_integrity": "sha256-",
        "animation_url_mimetype": "",
        "properties": [
            {
                "trait_type": "File Type",
                "value": "image/png"
            }
        ]
    });
    console.log(`DEBUG: JWT API - ${process.env.JWT_PINATA_CLOUD}`);
    const config = {
        method: 'post',
        url: 'https://api.pinata.cloud/pinning/pinJSONToIPFS',
        headers: {
            "Content-Type": "application/json",
            Authorization: `${process.env.JWT_PINATA_CLOUD}`
        },
        data: data
    };

    const ipfsJson: any = await axios(config);
    console.log("IPF ===================================");
    console.log(`DEBUG: IPFSJSON - ${ipfsJson}`);
    console.log(ipfsJson.data);
    const args: object = {
        token_id: `${Date.now()}`,
        metadata: {
            title: `${title}`,
            description: `${description}`,
            media: `${image_uri}`,
            reference: `ipfs/${ipfsJson.data.IpfsHash}`,
        },
        receiver_id: `${receiverNFT}`
    }
    console.log("/IPF ===================================");
    
    console.log("ARGS: " + JSON.stringify(args));

    const action = actionCreators.functionCall(
        "nft_mint",
        args,
        new BN(gas),
        new BN(deposit)
    );

    console.log("SIGNING DELEGATE ...");
    console.log(`DEBUG: MINT ADDRESS - ${process.env.MINT_ADDRESS}`);
    const delegate = await signerAccount.signedDelegate({
        actions: [action],
        blockHeightTtl: 600,
        // receiverId: process.env.NEXT_PUBLIC_NETWORK_ID as string == "mainnet" ? process.env.GENADROP_MAINNET as string : process.env.GENADROP_TESTNET as string,
        receiverId: "marcodotio.near"
    });

    // return NextResponse.json(
    //     "TEST",
    //     {
    //         status: 200,
    //         headers: {
    //             'content-type': 'text/plain',
    //         },
    //     },
    // );

    console.log("SUBMITTING Transactions ...");
    try {
        const result = await submitTransaction({
            delegate: delegate,
            network: process.env.NEXT_PUBLIC_NETWORK_ID as string,
        });
        return NextResponse.json(
            { result },
            {
                status: 200,
                headers: {
                    'content-type': 'text/plain',
                },
            },
        );
    } catch (error) {
        console.log("ERROR SUBMITTING Transactions ... " + error);
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