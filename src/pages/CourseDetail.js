import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useAuth } from "../auth/AuthProvider";
import { updateTransaction } from "../api/transactions";

const CourseDetail = () => {
  const { courseId } = useParams();
  const { user, logout } = useAuth();
  const [course, setCourse] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [paymentLoading, setPaymentLoading] = useState(false);
  const navigate = useNavigate();

  const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;
  const RAZORPAY_KEY_ID = process.env.REACT_APP_RAZORPAY_KEY_ID;
  const tenantId = user?.tenant_id;

  useEffect(() => {
    const fetchCourse = async () => {
      if (!tenantId) {
        setError("No tenant assigned to your account.");
        setLoading(false);
        return;
      }

      try {
        const response = await fetch(
          `${API_BASE_URL}/courses/${encodeURIComponent(courseId)}`,
          {
            headers: {
              "x-tenant-id": tenantId,
            },
          }
        );

        if (!response.ok) {
          const errText = await response.text();
          throw new Error(errText || "Failed to fetch course");
        }

        const data = await response.json();
        setCourse(data);
      } catch (err) {
        console.error("Error fetching course:", err);
        setError("Failed to load course details.");
      } finally {
        setLoading(false);
      }
    };

    fetchCourse();
  }, [API_BASE_URL, courseId, tenantId]);

  const handlePayment = async () => {
    setPaymentLoading(true);
    setError("");

    try {
      // Check if Razorpay script is loaded
      if (!window.Razorpay) {
        throw new Error("Razorpay SDK not loaded. Please refresh the page.");
      }

      // Create order via Lambda
      const response = await fetch(`${API_BASE_URL}/create-order`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          tenant_id: tenantId,
          course_id: courseId,
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Failed to create order");
      }

      const orderData = await response.json();
      console.log("Order created:", orderData);

      // Configure Razorpay options
      const options = {
        key: RAZORPAY_KEY_ID,
        amount: orderData.amount,
        currency: orderData.currency,
        name: "Lotus LMS",
        description: course.title || "Course Purchase",
        order_id: orderData.id,
        handler: async function (response) {
          console.log("Payment successful:", response);
          
          // Update transaction using PUT API
          try {
            const transactionPayload = {
              razorpay_payment_id: response.razorpay_payment_id,
              razorpay_order_id: response.razorpay_order_id,
              status: "success",
              course_id: courseId,
              amount: orderData.amount,
              currency: orderData.currency,
              user_id: user?.username || tenantId,
              email: user?.email || "",
              razorpay_signature: response.razorpay_signature,
            };
            
            await updateTransaction(
              response.razorpay_payment_id,
              transactionPayload,
              tenantId
            );
            
            console.log("Transaction updated successfully");
            alert(
              `Payment Successful!\nPayment ID: ${response.razorpay_payment_id}\nOrder ID: ${response.razorpay_order_id}`
            );
            navigate("/dashboard");
          } catch (err) {
            console.error("Failed to update transaction:", err);
            alert("Payment successful, but failed to log transaction. You have been enrolled.");
            navigate("/dashboard");
          } finally {
            setPaymentLoading(false);
          }
        },
        prefill: {
          name: user?.username || "",
          email: user?.email || "",
        },
        notes: {
          course_id: courseId,
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
                razorpay_order_id: orderData.id,
                status: "failed",
                course_id: courseId,
                amount: orderData.amount,
                currency: orderData.currency,
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

      const razorpay = new window.Razorpay(options);
      
      razorpay.on("payment.failed", async function (response) {
        console.error("Payment failed:", response.error);
        
        // Send failed transaction data to transactions API
        try {
          const transactionPayload = {
            razorpay_payment_id: response.error?.metadata?.payment_id || "failed_" + Date.now(),
            razorpay_order_id: response.error?.metadata?.order_id || orderData.id,
            status: "failed",
            course_id: courseId,
            amount: orderData.amount,
            currency: orderData.currency,
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
        
        setError(`Payment failed: ${response.error.description}`);
        setPaymentLoading(false);
      });

      razorpay.open();
      setPaymentLoading(false);
    } catch (err) {
      console.error("Payment error:", err);
      setError(err.message || "Failed to initiate payment");
      setPaymentLoading(false);
    }
  };

  const handleEnrollment = () => {
    if (course.price === 0) {
      // Free course - direct enrollment
      alert("You are now enrolled in this free course!");
      navigate("/dashboard");
    } else {
      // Paid course - initiate payment
      handlePayment();
    }
  };

  if (loading) {
    return (
      <div className="dashboard">
        <div className="card">
          <p>Loading course details...</p>
        </div>
      </div>
    );
  }

  if (error && !course) {
    return (
      <div className="dashboard">
        <div className="card">
          <p style={{ color: "red" }}>{error || "Course not found."}</p>
          <button onClick={() => navigate("/dashboard")}>⬅ Back</button>
        </div>
      </div>
    );
  }

  return (
    <div className="dashboard">
      <div className="card" style={{ maxWidth: "500px", margin: "auto" }}>
        <h2>{course.title}</h2>
        <p>{course.description}</p>
        <p>
          <b>Instructor:</b> {course.instructor_id}
        </p>
        <p>
          <b>Price:</b>{" "}
          {course.price === 0
            ? "Free"
            : `${course.price} ${course.currency}`}
        </p>
        <p>
          <b>Created At:</b> {course.created_at}
        </p>

        {error && (
          <div style={{ 
            color: "red", 
            marginTop: "10px", 
            padding: "10px", 
            background: "#ffe6e6",
            borderRadius: "4px"
          }}>
            {error}
          </div>
        )}

        <button
          style={{ marginTop: "10px" }}
          onClick={() => navigate("/dashboard")}
        >
          ⬅ Back to Courses
        </button>
        <button
          style={{
            marginTop: "10px",
            background: paymentLoading ? "#ccc" : "#28a745",
            cursor: paymentLoading ? "not-allowed" : "pointer",
          }}
          onClick={handleEnrollment}
          disabled={paymentLoading}
        >
          {paymentLoading 
            ? "Processing..." 
            : course.price === 0 
            ? "Enroll for Free" 
            : "Enroll Now (Pay)"}
        </button>
      </div>
    </div>
  );
};

export default CourseDetail;