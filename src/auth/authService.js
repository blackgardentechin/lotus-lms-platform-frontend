import axios from "axios";

const CLIENT_ID = "5ppt7ntr3a3ckvc670v71h920r";
const REDIRECT_URI = "https://dodyqytcfhwoe.cloudfront.net/";
const DOMAIN = "lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com";

export const exchangeCodeForToken = async (code) => {
  const body = new URLSearchParams({
    grant_type: "authorization_code",
    client_id: CLIENT_ID,
    redirect_uri: REDIRECT_URI,
    code,
  });

  const response = await axios.post(`https://${DOMAIN}/oauth2/token`, body, {
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
  });

  return response.data;
};

export const parseJwt = (token) => {
  try {
    return JSON.parse(atob(token.split(".")[1]));
  } catch (e) {
    console.error("Failed to parse JWT", e);
    return {};
  }
};