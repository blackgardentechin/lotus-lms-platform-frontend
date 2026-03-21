// src/api/transactions.js

/**
 * Update transaction status after payment completion
 * @param {string} transactionId - The transaction ID (typically razorpay_payment_id)
 * @param {object} payload - Transaction data
 * @param {string} tenantId - Tenant ID for multi-tenancy
 * @returns {Promise} - API response
 */
export async function updateTransaction(transactionId, payload, tenantId) {
  const baseUrl = process.env.REACT_APP_API_BASE_URL;
  if (!baseUrl) {
    console.warn('No API base URL configured');
    return null;
  }
  
  const url = `${baseUrl}/transactions/${transactionId}`;
  
  const res = await fetch(url, {
    method: 'PUT',
    headers: { 
      'Content-Type': 'application/json',
      'X-Tenant-Id': tenantId
    },
    body: JSON.stringify(payload),
  });
  
  if (!res.ok) {
    const errorData = await res.json().catch(() => ({}));
    throw new Error(errorData.error || `Transaction API returned ${res.status}`);
  }
  
  return res.json();
}
