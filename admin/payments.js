const API_URL = "http://127.0.0.1:8000";

let allPayments = [];

function formatMoney(n) {
    return "$" + n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function renderStats(payments) {
    // គណនាតួលេខតាម status ពិតប្រាកដពី Database
    const received = payments.filter(p => p.status === "success" || p.status === "completed").reduce((s, p) => s + p.amount, 0);
    const pending = payments.filter(p => p.status === "pending").reduce((s, p) => s + p.amount, 0);
    const refunded = payments.filter(p => p.status === "refunded").reduce((s, p) => s + p.amount, 0);
    const failed = payments.filter(p => p.status === "failed").length;

    document.getElementById("statReceived").textContent = formatMoney(received);
    document.getElementById("statPending").textContent = formatMoney(pending);
    document.getElementById("statRefunded").textContent = formatMoney(refunded);
    document.getElementById("statFailed").textContent = failed;
}

function renderTable(payments) {
    const tbody = document.getElementById("paymentsTableBody");

    if (!Array.isArray(payments) || payments.length === 0) {
        tbody.innerHTML = `<tr><td colspan="6" class="text-center">No transactions match your search.</td></tr>`;
        return;
    }

    tbody.innerHTML = payments.map(p => `
        <tr>
            <td><strong>${p.id}</strong></td>
            <td>${p.customer}</td>
            <td style="color:#16a34a; font-weight:600;">${formatMoney(p.amount)}</td>
            <td>${p.method}</td>
            <td><span class="status-badge ${p.status.toLowerCase()}">${p.status.charAt(0).toUpperCase() + p.status.slice(1)}</span></td>
            <td>${p.date}</td>
        </tr>
    `).join("");
}

function applyFilters() {
    const query = document.getElementById("searchInput").value.trim().toLowerCase();
    const status = document.getElementById("statusFilter").value;

    const filtered = allPayments.filter(p => {
        const matchesQuery = !query ||
            p.customer.toLowerCase().includes(query) ||
            p.id.toLowerCase().includes(query);
        const matchesStatus = status === "all" || p.status.toLowerCase() === status.toLowerCase();
        return matchesQuery && matchesStatus;
    });

    renderTable(filtered);
}

// 📌 មុខងារទាញយកទិន្នន័យពិតប្រាកដពី FastAPI Backend (/payments/)
async function fetchPaymentsData() {
    try {
        const response = await fetch(`${API_URL}/payments/`);
        allPayments = await response.json();
        
        renderStats(allPayments);
        renderTable(allPayments);
    } catch (error) {
        console.error("Error fetching payments from API:", error);
        document.getElementById("paymentsTableBody").innerHTML = `<tr><td colspan="6" class="text-center" style="color:red;">Failed to load data from API</td></tr>`;
    }
}

document.getElementById("searchInput").addEventListener("input", applyFilters);
document.getElementById("statusFilter").addEventListener("change", applyFilters);

// រត់ទាញយកទិន្នន័យពេល Load ទំព័រ
fetchPaymentsData();