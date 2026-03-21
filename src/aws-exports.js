import { Amplify } from "aws-amplify";

Amplify.configure({
  Auth: {
    region: "ap-south-1",
    userPoolId: "ap-south-1_6C5lP9yfm",   // Updated to original user pool
    userPoolWebClientId: "5ppt7ntr3a3ckvc670v71h920r",   // Updated to original client ID
    oauth: {
      domain: "lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com",
      scope: ["email", "openid", "profile"],
      redirectSignIn: "https://dodyqytcfhwoe.cloudfront.net",
      redirectSignOut: "https://dodyqytcfhwoe.cloudfront.net",
      responseType: "code"
    }
  }
});