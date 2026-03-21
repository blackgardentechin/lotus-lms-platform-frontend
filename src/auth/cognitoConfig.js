/**
 * Cognito Configuration Module
 * 
 * This module reads Cognito client IDs from environment variables:
 * - REACT_APP_DIRECT_AUTH_CLIENT_ID: For email/password authentication
 * - REACT_APP_OAUTH_CLIENT_ID: For Google OAuth authentication
 */

export const COGNITO_CONFIG = {
  // Direct Auth Client ID for email/password login and signup
  DIRECT_AUTH_CLIENT_ID: process.env.REACT_APP_DIRECT_AUTH_CLIENT_ID || "78cfqtlh63cj8q8eht4hka7om7",
  
  // OAuth Client ID for Google OAuth flow
  OAUTH_CLIENT_ID: process.env.REACT_APP_OAUTH_CLIENT_ID || "1d46et2aoichnr8jbupvldi0c3",
  
  // User Pool ID
  USER_POOL_ID: process.env.REACT_APP_USER_POOL_ID || "ap-south-1_kaEBPbIxW",
  
  // Cognito Domain
  COGNITO_DOMAIN: process.env.REACT_APP_COGNITO_DOMAIN || "https://lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com",
  
  // Redirect URIs
  REDIRECT_URI: process.env.REACT_APP_REDIRECT_URL || "https://dodyqytcfhwoe.cloudfront.net/",
  SIGNOUT_URI: process.env.REACT_APP_SIGNOUT_URL || "https://dodyqytcfhwoe.cloudfront.net/",
  
  // Region
  REGION: process.env.REACT_APP_REGION || "ap-south-1",
};

// Helper function to get the correct client ID based on auth type
export const getClientId = (authType = "direct") => {
  return authType === "oauth" 
    ? COGNITO_CONFIG.OAUTH_CLIENT_ID 
    : COGNITO_CONFIG.DIRECT_AUTH_CLIENT_ID;
};

// Validate that required env vars are set
export const validateCognitoConfig = () => {
  const required = ["DIRECT_AUTH_CLIENT_ID", "OAUTH_CLIENT_ID", "USER_POOL_ID", "COGNITO_DOMAIN"];
  const missing = required.filter(key => !COGNITO_CONFIG[key]);
  
  if (missing.length > 0) {
    console.warn("⚠️ Missing Cognito configuration:", missing);
  }
  
  return missing.length === 0;
};
