// import { SignedDelegate } from '@near-js/transactions';
// import { deserialize } from 'borsh';
// import { NextResponse } from 'next/server';

// import { createAccount, submitTransaction, connect } from '../../../utils/meta-transactions';
// import { SCHEMA } from '@/helper/utils/near/types/schema';

// export async function POST(req: Request) {
//   const body = await req.json();

//   const deserializeDelegate = deserialize(SCHEMA, SignedDelegate, Buffer.from(new Uint8Array(body)));

//   const result = await submitTransaction({
//     delegate: deserializeDelegate,
//     network: process.env.NEXT_PUBLIC_NETWORK_ID as string,
//   });

//   return NextResponse.json(
//     { result },
//     {
//       status: 200,
//       headers: {
//         'content-type': 'application/json',
//       },
//     },
//   );
// }

import { submitTransaction } from "@/utils/meta-transactions";
import { SCHEMA } from "@/utils/schema";
import { SignedDelegate } from "@near-js/transactions";
import { deserialize } from "borsh";
import { NextResponse } from "next/server";

export async function POST(req: Request) {
  const body = await req.json();
  const { delegated, network } = body;

  const deserializeDelegate = deserialize(
    SCHEMA,
    SignedDelegate,
    Buffer.from(new Uint8Array(delegated))
  );

  const result = await submitTransaction({
    delegate: deserializeDelegate,
    network,
  });

  return NextResponse.json(
    { result },
    {
      status: 200,
      headers: {
        "content-type": "application/json",
      },
    }
  );
}