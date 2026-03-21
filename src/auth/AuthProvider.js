import React, { createContext, useContext, useEffect, useState } from "react";
import { exchangeCodeForToken, parseJwt } from "./authService";

const AuthContext = createContext();
export const useAuth = () => useContext(AuthContext);

const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;

/**
 * Fetch user tenant mapping from backend API
 * @param {string} userId - The user ID to fetch tenant mapping for
 * @returns {Promise<Object|null>} The tenant mapping object or null if failed
 */
export const fetchUserTenant = async (userId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/user/tenant?user_id=${userId}`, {
      headers: {
        "Content-Type": "application/json",
      }
    });
    
    if (!response.ok) {
      throw new Error("Failed to fetch tenant mapping");
    }
    
    const data = await response.json();
    return data; // { user_id, tenant_id, role, email, created_at }
  } catch (error) {
    console.error("Error fetching tenant mapping:", error);
    return null;
  }
};

/**
 * Helper function to determine and persist canonical username
 * Priority: localStorage → pendingUsername → cognito:username → preferred_username → email
 * 
 * Note: localStorage username takes priority to maintain consistency across sessions.
 * This ensures the tenant_id remains stable for API calls even if token claims change.
 * 
 * @param {Object} payload - The parsed JWT token payload
 * @param {string|null} pendingUsername - Optional username from signup flow
 * @returns {string|null} The canonical username, or null if none can be determined
 */
export const determineAndPersistUsername = (payload, pendingUsername = null) => {
  // Guard clause: ensure payload exists
  // Returns null without persisting when payload is invalid
  if (!payload || typeof payload !== 'object') {
    return null;
  }

  // 1. Check if username already exists in localStorage
  // This maintains consistency for returning users and ensures stable tenant_id
  // We trust localStorage since it was set by this same function in a previous session
  const existingUsername = localStorage.getItem("username");
  if (existingUsername) {
    return existingUsername;
  }

  // 2. Use pending username from signup flow
  if (pendingUsername) {
    localStorage.setItem("username", pendingUsername);
    return pendingUsername;
  }

  // 3. Try cognito:username claim
  if (payload["cognito:username"]) {
    localStorage.setItem("username", payload["cognito:username"]);
    return payload["cognito:username"];
  }

  // 4. Try preferred_username claim
  if (payload.preferred_username) {
    localStorage.setItem("username", payload.preferred_username);
    return payload.preferred_username;
  }

  // 5. Fallback to email
  if (payload.email) {
    localStorage.setItem("username", payload.email);
    return payload.email;
  }

  return null;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [errorMessage, setErrorMessage] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);

    // 🔴 Handle Cognito redirect errors
    const error = params.get("error");
    const errorDescription = params.get("error_description");

    if (error) {
      const formattedError = decodeURIComponent(errorDescription || "Login failed.");
      console.error("Cognito returned an error:", formattedError);

      if (formattedError.toLowerCase().includes("not enabled")) {
        setErrorMessage("Your account has not been enabled yet. Please contact support.");
      } else if (formattedError.toLowerCase().includes("disabled")) {
        setErrorMessage("Your account has been disabled. Please contact the administrator.");
      } else {
        setErrorMessage(formattedError);
      }

      window.history.replaceState({}, document.title, "/");
      setLoading(false);
      return;
    }

    // 🟢 Handle OAuth2 redirect (Google / Hosted UI)
    const code = params.get("code");
    if (code) {
      exchangeCodeForToken(code)
        .then(async (tokens) => {
          localStorage.setItem("id_token", tokens.id_token);
          const payload = parseJwt(tokens.id_token);
          
          // Retrieve pending username and topic from sessionStorage (set during Google signup)
          const pendingUsername = sessionStorage.getItem("pending_google_username");
          const pendingTopic = sessionStorage.getItem("pending_google_topic");
          
          // Store topic in localStorage if provided
          if (pendingTopic) {
            localStorage.setItem("user_topic", pendingTopic);
          }
          
          // Clear pending values from sessionStorage
          sessionStorage.removeItem("pending_google_username");
          sessionStorage.removeItem("pending_google_topic");
          
          // Determine and persist canonical username
          const username = determineAndPersistUsername(payload, pendingUsername);
          
          // Fetch tenant mapping from backend
          const tenantMapping = await fetchUserTenant(username);
          
          if (!tenantMapping) {
            setErrorMessage("Your account is not assigned to any organization. Please contact support.");
            setLoading(false);
            return;
          }
          
          // Set user state with username, email, tenant_id, and role
          setUser({ 
            name: payload.name || payload.email,
            username: username,
            email: payload.email,
            tenant_id: tenantMapping.tenant_id,
            role: tenantMapping.role
          });
          window.history.replaceState({}, document.title, "/dashboard");
        })
        .catch((err) => {
          console.error("Token exchange failed:", err);

          let errorText = "Login failed. Please try again.";
          if (err.response?.data?.error_description)
            errorText = err.response.data.error_description;
          else if (typeof err.response?.data === "string")
            errorText = err.response.data;
          else if (err.message)
            errorText = err.message;

          if (errorText.toLowerCase().includes("disabled")) {
            setErrorMessage("Your account has been disabled. Please contact the administrator.");
          } else {
            setErrorMessage("Login failed: " + errorText);
          }

          window.history.replaceState({}, document.title, "/");
        })
        .finally(() => setLoading(false));
    } else {
      // 🟣 Load user from localStorage (for SDK login)
      const token = localStorage.getItem("id_token");
      if (token) {
        const payload = parseJwt(token);
        // Determine and persist canonical username using helper
        const username = determineAndPersistUsername(payload, null);
        
        // Fetch tenant mapping from backend
        (async () => {
          try {
            const tenantMapping = await fetchUserTenant(username);
            
            if (!tenantMapping) {
              setErrorMessage("Your account is not assigned to any organization. Please contact support.");
              setLoading(false);
              return;
            }
            
            setUser({ 
              name: payload.name || payload.email,
              username: username,
              email: payload.email,
              tenant_id: tenantMapping.tenant_id,
              role: tenantMapping.role
            });
            setLoading(false);
          } catch (err) {
            console.error("Failed to fetch tenant mapping:", err);
            setErrorMessage("Failed to load account information. Please try logging in again.");
            setLoading(false);
          }
        })();
      } else {
        setLoading(false);
      }
    }
  }, []);

  // 🚀 Dual-mode logout handler (Hosted UI + SDK)
  const logout = async () => {
    try {
      localStorage.removeItem("id_token");
      localStorage.removeItem("username");
      localStorage.removeItem("user_topic");
      setUser(null);

      // Hosted UI logout for Google/OAuth users
      const domain = "lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com";
      const clientId = "49gusp4sidkggc371vghtdvujb";
      const redirectUri = window.location.origin.includes("localhost")
        ? "http://localhost:3000/"
        : "https://dodyqytcfhwoe.cloudfront.net/";

      // Try to sign out SDK user first (username/password)
      const { CognitoUserPool } = await import("amazon-cognito-identity-js");
      const poolData = {
        UserPoolId: "ap-south-1_6C5lP9yfm",
        ClientId: "49gusp4sidkggc371vghtdvujb",
      };
      const userPool = new CognitoUserPool(poolData);
      const cognitoUser = userPool.getCurrentUser();

      if (cognitoUser) {
        cognitoUser.signOut();
        window.location.href = "/"; // go to login (home)
        return;
      }

      // If no SDK session, fallback to Hosted UI logout
      const logoutUrl = `https://${domain}/logout?client_id=${clientId}&logout_uri=${encodeURIComponent(
        redirectUri
      )}`;
      console.log("Redirecting to Cognito logout:", logoutUrl);
      window.location.href = logoutUrl;
    } catch (err) {
      console.error("Logout failed:", err);
      window.location.href = "/";
    }
  };

  return (
    <AuthContext.Provider
      value={{ user, setUser, logout, errorMessage, setErrorMessage }}
    >
      {!loading && children}
      {errorMessage && (
        <div className="error-banner">
          ⚠️ {errorMessage}
        </div>
      )}
    </AuthContext.Provider>
  );
};