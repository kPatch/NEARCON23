import { NextResponse } from 'next/server';
import { KeyPair } from "@near-js/crypto";
import { InMemoryKeyStore } from "@near-js/keystores";
import { actionCreators } from "@near-js/transactions";
import axios from "axios";
import BN from "bn.js";
import { connect, submitTransaction } from "@/utils/meta-transactions";

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
        "RECEIVER NFT: " + receiverNFT);

    const keyStore = new InMemoryKeyStore();

    await keyStore.setKey(
        process.env.NEXT_PUBLIC_NETWORK_ID as string,
        accountId,
        KeyPair.fromString(privateKey)
    );

    const signerAccount = await connect(
        accountId,
        keyStore,
        process.env.NEXT_PUBLIC_NETWORK_ID as string
    );

    const gas = "300000000000000";
    const deposit = "10000000000000000000000";

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

    const config = {
        method: 'post',
        url: 'https://api.pinata.cloud/pinning/pinJSONToIPFS',
        headers: {
            "Content-Type": "application/json",
            Authorization: process.env.JWT_PINATA_CLOUD
        },
        data: data
    };

    const ipfsJson: any = await axios(config);
    console.log(ipfsJson);
    const args: object = {
        token_id: `${Date.now()}`,
        metadata: {
            title: title,
            description: description,
            media: `https://gateway.pinata.cloud/ipfs/${cid}`,
            reference: `ipfs/${ipfsJson.data.IpfsHash}`,
        },
        receiver_id: receiverNFT
    }
    console.log("ARGS: " + JSON.stringify(args));

    const action = actionCreators.functionCall(
        "nft_mint",
        args,
        new BN(gas),
        new BN(deposit)
    );

    console.log("SIGNING DELEGATE ...");
    const delegate = await signerAccount.signedDelegate({
        actions: [action],
        blockHeightTtl: 600,
        receiverId: process.env.NEXT_PUBLIC_NETWORK_ID as string == "mainnet" ? process.env.GENADROP_MAINNET as string : process.env.GENADROP_TESTNET as string,
    });

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