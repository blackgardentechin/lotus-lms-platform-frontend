import React, { useState } from "react";
import { CognitoUserPool, CognitoUserAttribute } from "amazon-cognito-identity-js";
import { Link } from "react-router-dom";

const poolData = {
  UserPoolId: "ap-south-1_6C5lP9yfm", // 🔁 replace with your Cognito User Pool ID
  ClientId: "5ppt7ntr3a3ckvc670v71h920r", // 🔁 your App Client ID
};

const userPool = new CognitoUserPool(poolData);

// Topic options for interest selection
const TOPIC_OPTIONS = [
  { value: "", label: "Select a topic" },
  { value: "Cloud", label: "Cloud" },
  { value: "AI", label: "AI" },
  { value: "Full Stack", label: "Full Stack" },
  { value: "Testing", label: "Testing" },
];

const Signup = () => {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState(""); // Add confirm password
  const [topic, setTopic] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  
  // Google signup flow state
  const [showGoogleUsernamePrompt, setShowGoogleUsernamePrompt] = useState(false);
  const [googleUsername, setGoogleUsername] = useState("");
  const [googleTopic, setGoogleTopic] = useState("");

  const handleEmailSignup = (e) => {
    e.preventDefault();

    setMessage("");
    setError("");

    // Password validation
    if (password !== confirmPassword) {
      setError("Passwords do not match");
      return;
    }

    if (password.length < 8) {
      setError("Password must be at least 8 characters long");
      return;
    }

    const attributeList = [
      new CognitoUserAttribute({ Name: "email", Value: email }),
    ];

    if (topic && topic !== "") {
      try {
        attributeList.push(
          new CognitoUserAttribute({ 
            Name: "custom:interest",
            Value: topic 
          })
        );
      } catch (err) {
        console.warn("Failed to add custom attribute:", err);
      }
    }

    userPool.signUp(username, password, attributeList, null, (err, result) => {
      if (err) {
        console.error("Signup error:", err);
        setError(err.message || "Signup failed. Please try again.");
        return;
      }

      console.log("Signup success:", result);
      setMessage("Signup successful! Please check your email for a verification link.");
    });
  };

  // Show username prompt before Google OAuth redirect
  const handleGoogleSignup = () => {
    setShowGoogleUsernamePrompt(true);
    setError("");
  };

  // Proceed with Google signup after username is entered
  const proceedWithGoogleSignup = () => {
    // Validate username (minimum 3 characters)
    if (!googleUsername || googleUsername.trim().length < 3) {
      setError("Username must be at least 3 characters");
      return;
    }

    // Store username and topic in sessionStorage for retrieval after OAuth
    sessionStorage.setItem("pending_google_username", googleUsername.trim());
    if (googleTopic) {
      sessionStorage.setItem("pending_google_topic", googleTopic);
    }

    // Redirect to Google OAuth
    const DOMAIN = "lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com";
    const REDIRECT_URI = "https://dodyqytcfhwoe.cloudfront.net/";
    const CLIENT_ID = "5ppt7ntr3a3ckvc670v71h920r";

    // Use URLSearchParams to properly encode parameters
    const params = new URLSearchParams({
      client_id: CLIENT_ID,
      response_type: 'code',
      scope: 'email openid profile',  // Space-separated scopes
      redirect_uri: REDIRECT_URI,
      identity_provider: 'Google'
    });

    const url = `https://${DOMAIN}/oauth2/authorize?${params.toString()}`;
    window.location.href = url;
  };

  // Go back to main signup form
  const handleBackFromGooglePrompt = () => {
    setShowGoogleUsernamePrompt(false);
    setGoogleUsername("");
    setGoogleTopic("");
    setError("");
  };

  return (
    <div className="login-container">
      <div className="login-card">
        {showGoogleUsernamePrompt ? (
          // Google Username Prompt Modal
          <>
            <h1>Choose Username</h1>
            <p className="form-subtitle">
              Enter a username before continuing with Google
            </p>
            <input
              type="text"
              placeholder="Username (min 3 characters)"
              value={googleUsername}
              onChange={(e) => setGoogleUsername(e.target.value)}
              minLength={3}
            />
            <label>Interested Topics (Optional)</label>
            <select value={googleTopic} onChange={(e) => setGoogleTopic(e.target.value)}>
              {TOPIC_OPTIONS.map((opt) => (
                <option key={opt.value} value={opt.value}>{opt.label}</option>
              ))}
            </select>
            
            {error && <p className="error-text">{error}</p>}
            
            <button className="google-btn" onClick={proceedWithGoogleSignup}>
              <img
                src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg"
                alt="Google"
              />
              Continue with Google
            </button>
            <button 
              type="button" 
              onClick={handleBackFromGooglePrompt}
              className="back-btn"
            >
              Back
            </button>
          </>
        ) : (
          // Main Signup Form
          <>
            <h1>Create Account</h1>
            <form onSubmit={handleEmailSignup}>
              <input
                type="text"
                placeholder="Username"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
                minLength={3}
              />
              <input
                type="email"
                placeholder="Email Address"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
              <input
                type="password"
                placeholder="Password (min 8 characters)"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={8}
              />
              <input
                type="password"
                placeholder="Confirm Password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
                minLength={8}
              />
              <label>Interested Topics (Optional)</label>
              <select value={topic} onChange={(e) => setTopic(e.target.value)}>
                {TOPIC_OPTIONS.map((opt) => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </select>
              <button type="submit">Sign Up</button>
            </form>

            {error && <p className="error-text">{error}</p>}
            {message && <p className="success-text">{message}</p>}

            <div className="divider">OR</div>
            
            <button className="google-btn" onClick={handleGoogleSignup}>
              <img
                src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg"
                alt="Google"
              />
              Sign up with Google
            </button>
            
            <p>
              Already have an account? <Link to="/">Sign in</Link>
            </p>
          </>
        )}
      </div>
    </div>
  );
};

export default Signup;