import React from 'react';
import { Auth } from 'aws-amplify';
import './Login.css'; // Assuming you have a CSS file for styling

const Login = () => {
    const handleLogin = async (event) => {
        event.preventDefault();
        const username = event.target.username.value;
        const password = event.target.password.value;
        try {
            await Auth.signIn(username, password);
            // Handle successful login
        } catch (error) {
            console.error('Error signing in', error);
            // Handle errors
        }
    };

    return (
        <div className="login-container">
            <h2>Login</h2>
            <form onSubmit={handleLogin}>
                <div className="input-group">
                    <label htmlFor="username">Username:</label>
                    <input type="text" id="username" name="username" required />
                </div>
                <div className="input-group">
                    <label htmlFor="password">Password:</label>
                    <input type="password" id="password" name="password" required />
                </div>
                <button type="submit" className="login-button">Login</button>
                <button type="button" className="signup-button" onClick={() => {/* Navigate to signup */}}>Sign Up</button>
            </form>
        </div>
    );
};

export default Login;