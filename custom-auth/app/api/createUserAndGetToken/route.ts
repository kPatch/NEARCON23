import type { NextApiRequest, NextApiResponse } from 'next';
import { NextResponse } from 'next/server';
import { FirebaseError } from 'firebase/app';
import dotenv from "dotenv";

import * as admin from 'firebase-admin';

// const serviceAccountJsonPath = process.env.SERVICE_ACCOUNT_JSON;
import serviceAccount from '../nearcon23-firebase-adminsdk-d93ck-0d4094232f.json';



function getApp() {
  let app;
  try {
    app = admin.initializeApp(
      {
        credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
      },
      'my-app',
    );
  } catch (error) {
    app = admin.app('my-app');
  }
  return app;
}


// export default async (req: NextApiRequest, res: NextApiResponse) => {
// const auth = getApp().auth();
//   type SignUpData = {
//     email: string;
//     password: string;
//   };
//   const body = req.body as SignUpData;
// //   const body = req.body;
//   try {
//     const user = await auth.createUser(body);
//     const token = await auth.createCustomToken(user.uid, {
//       isAdmin: true,
//      //... add other custom claims as need be
//     });
//     console.log("TOKEN RESPONSE: " + token);
//     res.send({ token });
//   } catch (error) {
//     if (error instanceof FirebaseError) res.status(400).json({ message: error.message });
//   }
// };

export async function POST(req: Request) {

  const auth = getApp().auth();
  // type SignUpData = {
  //   email: string;
  //   password: string;
  // };

  const body = await req.json();
  const { email, password } = body;

  try {
    const user = await auth.createUser(body);
    const token = await auth.createCustomToken(user.uid, {
      isAdmin: true,
      //... add other custom claims as need be
    });
    console.log("TOKEN RESPONSE: " + token);

    return NextResponse.json(
      { token },
      {
        status: 200,
        headers: {
          'content-type': 'text/plain',
        },
      },
    );
  } catch (error) {
    // if (error instanceof FirebaseError) res.status(400).json({ message: error.message });
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