import React, { useEffect, useState } from "react";
import { useAuth } from "../auth/AuthProvider";
import { updateTransaction } from "../api/transactions";

const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;
const RAZORPAY_KEY_ID = process.env.REACT_APP_RAZORPAY_KEY_ID;

const Dashboard = () => {
  const { user, logout } = useAuth();
  const [courses, setCourses] = useState([]);
  const [error, setError] = useState("");
  const [selectedCourse, setSelectedCourse] = useState(null);
  const [paymentLoading, setPaymentLoading] = useState(false);

  const tenantId = user?.tenant_id;

  // Fetch courses
  useEffect(() => {
    // Debug logging
    console.log("User tenant_id:", tenantId);
    console.log("User object:", user);
    
    if (!tenantId) {
      setError("No tenant assigned to your account. Please contact support.");
      return;
    }

    fetch(`${API_BASE_URL}/courses`, {
      headers: { "x-tenant-id": tenantId },
    })
      .then((res) => res.json())
      .then((data) => setCourses(data.items || []))
      .catch(() =>
        setError("Unable to load courses. Please try again later.")
      );
  }, [tenantId, user]);

  // Load Razorpay checkout script if not already loaded
  const loadRazorpayScript = () => {
    return new Promise((resolve) => {
      if (window.Razorpay) {
        resolve(true);
        return;
      }
      const script = document.createElement("script");
      script.src = "https://checkout.razorpay.com/v1/checkout.js";
      script.onload = () => resolve(true);
      script.onerror = () => resolve(false);
      document.body.appendChild(script);
    });
  };

  const createOrder = async (course) => {
    setPaymentLoading(true);
    setError("");

    try {
      const scriptLoaded = await loadRazorpayScript();
      if (!scriptLoaded) {
        throw new Error("Failed to load Razorpay SDK. Refresh and try again.");
      }

      const resp = await fetch(`${API_BASE_URL}/create-order`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          tenant_id: tenantId,
          course_id: course.course_id,
        }),
      });

      if (!resp.ok) {
        const errBody = await resp.json().catch(() => ({}));
        throw new Error(errBody.error || "Failed to create order");
      }

      const order = await resp.json();
      return order;
    } catch (err) {
      console.error("createOrder error:", err);
      setError(err.message || "Failed to create order");
      setPaymentLoading(false);
      return null;
    }
  };

  const openRazorpayCheckout = (order, course) => {
    const options = {
      key: RAZORPAY_KEY_ID,
      amount: order.amount,
      currency: order.currency,
      name: "Lotus LMS",
      description: course.title || "Course Purchase",
      order_id: order.id,
      handler: async function (response) {
        console.log("razorpay success response", response);
        
        // Update transaction using PUT API
        try {
          const transactionPayload = {
            razorpay_payment_id: response.razorpay_payment_id,
            razorpay_order_id: response.razorpay_order_id,
            status: "success",
            course_id: course.course_id,
            amount: order.amount,
            currency: order.currency,
            user_id: user?.username || tenantId,
            email: user?.email || "",
            razorpay_signature: response.razorpay_signature,
          };
          
          await updateTransaction(
            response.razorpay_payment_id, // Use payment ID as transaction ID
            transactionPayload,
            tenantId
          );
          
          console.log("Transaction updated successfully");
          alert("Payment successful — you are enrolled!");
        } catch (err) {
          console.error("Failed to update transaction:", err);
          alert("Payment successful, but failed to log transaction. Please contact support.");
        }
        
        setSelectedCourse(null);
        setPaymentLoading(false);
      },
      prefill: {
        name: user?.name || user?.username || "",
        email: user?.email || "",
      },
      notes: {
        course_id: course.course_id,
        tenant_id: tenantId,
      },
      theme: {
        color: "#4F46E5",
      },
      modal: {
        ondismiss: async function() {
          // User closed the payment modal - mark as failed
          try {
            const transactionPayload = {
              razorpay_payment_id: "failed_" + Date.now(),
              razorpay_order_id: order.id,
              status: "failed",
              course_id: course.course_id,
              amount: order.amount,
              currency: order.currency,
              user_id: user?.username || tenantId,
            };
            
            await updateTransaction(
              transactionPayload.razorpay_payment_id,
              transactionPayload,
              tenantId
            );
          } catch (err) {
            console.error("Failed to log failed transaction:", err);
          }
          
          setPaymentLoading(false);
        }
      },
    };

    const rzp = new window.Razorpay(options);

    rzp.on("payment.failed", async function (response) {
      console.error("Payment failed", response);
      
      // Send failed transaction data to transactions API
      try {
        const transactionPayload = {
          razorpay_payment_id: response.error?.metadata?.payment_id || "failed_" + Date.now(),
          razorpay_order_id: response.error?.metadata?.order_id || order.id,
          status: "failed",
          course_id: course.course_id,
          amount: order.amount,
          currency: order.currency,
          user_id: user?.username || tenantId,
        };
        await updateTransaction(
          transactionPayload.razorpay_payment_id,
          transactionPayload,
          tenantId
        );
        console.log("Failed transaction logged");
      } catch (err) {
        console.error("Failed to log transaction:", err);
      }
      
      setError(
        response?.error?.description || "Payment failed. Please try again."
      );
      setPaymentLoading(false);
    });

    rzp.open();
  };

  const handleEnrollClick = async (course) => {
    // For free courses, skip payment flow
    if (course.price === 0) {
      alert("You are now enrolled in this free course!");
      return;
    }

    setSelectedCourse(course);
    setPaymentLoading(true);
    const order = await createOrder(course);
    if (order) {
      openRazorpayCheckout(order, course);
    }
  };

  return (
    <div className="dashboard">
      <div className="card">
        <h2>✅ Logged in successfully!</h2>
        <p>Welcome, {user?.name || "User"} 🎉</p>
        <div className="button-group">
          <button className="my-courses-btn">My Courses</button>
          <button onClick={logout}>Logout</button>
        </div>
      </div>

      <div className="courses-section">
        <h3>📚 Available Courses</h3>
        {error && <p className="error">{error}</p>}

        <div className="course-list">
          {courses.map((course) => (
            <div className="course-card" key={course.course_id}>
              <h4>{course.title}</h4>
              <p>{course.description}</p>
              <p>
                💰 <strong>{course.price}</strong> {course.currency}
              </p>
              <button
                onClick={() => handleEnrollClick(course)}
                className="buy-btn enroll-button"
                disabled={paymentLoading}
              >
                {paymentLoading && selectedCourse?.course_id === course.course_id
                  ? "Processing..."
                  : course.price === 0
                  ? "Enroll for Free"
                  : "Enroll Now"}
              </button>
            </div>
          ))}
        </div>
      </div>

      {selectedCourse && (
        <div className="payment-modal">
          <div className="payment-card">
            <h4>Proceed to Payment</h4>
            <p>
              You are purchasing: <strong>{selectedCourse.title}</strong>
            </p>
            <p>
              Amount: <strong>{selectedCourse.currency} {selectedCourse.price}</strong>
            </p>
            <div style={{ marginTop: 12 }}>
              <small>
                The Razorpay checkout will open. Complete the payment to get
                access to the course.
              </small>
            </div>
            <button
              className="cancel-btn"
              onClick={() => {
                setSelectedCourse(null);
                setPaymentLoading(false);
              }}
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Dashboard;