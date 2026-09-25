const API_URL = "http://127.0.0.1:8000";

let allCustomers = [];

function formatMoney(n) {
    return "$" + n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function initials(name) {
    if (!name) return "U";
    return name.split(" ").map(w => w[0]).join("").toUpperCase().slice(0, 2);
}

function renderStats(customers) {
    const total = customers.length;
    const newThisMonth = customers.filter(c => c.status === "new").length;
    const repeat = customers.filter(c => c.orders > 1).length;
    const totalSpendSum = customers.reduce((s, c) => s + c.spent, 0);
    const avgSpend = total > 0 ? totalSpendSum / total : 0;

    document.getElementById("statTotalCustomers").textContent = total;
    document.getElementById("statNewCustomers").textContent = newThisMonth;
    document.getElementById("statRepeatCustomers").textContent = repeat;
    document.getElementById("statAvgSpend").textContent = formatMoney(avgSpend);
}

function renderTable(customers) {
    const tbody = document.getElementById("customersTableBody");

    if (!Array.isArray(customers) || customers.length === 0) {
        tbody.innerHTML = `<tr><td colspan="5" class="text-center">No customers match your search.</td></tr>`;
        return;
    }

    tbody.innerHTML = customers.map(c => `
        <tr>
            <td>
                <div class="cust-cell">
                    <div class="avatar">${initials(c.name)}</div>
                    <div>
                        <div class="cust-name">${c.name}</div>
                        <div class="cust-email">${c.email}</div>
                    </div>
                </div>
            </td>
            <td>${c.orders}</td>
            <td style="color:#16a34a; font-weight:600;">${formatMoney(c.spent)}</td>
            <td>${c.joined}</td>
            <td><span class="status-badge ${c.status === 'new' ? 'pending' : 'success'}">${c.status === 'new' ? 'New' : 'Active'}</span></td>
        </tr>
    `).join("");
}

function applyFilters() {
    const query = document.getElementById("searchInput").value.trim().toLowerCase();
    const sort = document.getElementById("sortFilter").value;

    let filtered = allCustomers.filter(c =>
        !query || c.name.toLowerCase().includes(query) || c.email.toLowerCase().includes(query)
    );

    if (sort === "spend") filtered = [...filtered].sort((a, b) => b.spent - a.spent);
    else if (sort === "orders") filtered = [...filtered].sort((a, b) => b.orders - a.orders);
    else filtered = [...filtered].sort((a, b) => new Date(b.joined) - new Date(a.joined));

    renderTable(filtered);
}

// ទាញយកទិន្នន័យពី FastAPI Backend (/customers/)
async function fetchCustomersData() {
    try {
        const response = await fetch(`${API_URL}/customers/`);
        allCustomers = await response.json();
        
        renderStats(allCustomers);
        applyFilters();
    } catch (error) {
        console.error("Error fetching customers:", error);
        document.getElementById("customersTableBody").innerHTML = `<tr><td colspan="5" class="text-center" style="color:red;">Failed to load customers from API</td></tr>`;
    }
}

document.getElementById("searchInput").addEventListener("input", applyFilters);
document.getElementById("sortFilter").addEventListener("change", applyFilters);


fetchCustomersData();