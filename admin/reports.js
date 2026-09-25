// Category performance and "top products" use your real /products/ data.
// Sales trend uses sample revenue numbers since there's no /orders/ endpoint
// yet — swap SALES_DATA for a real fetch once one exists.

const API_URL = "http://127.0.0.1:8000";
const PALETTE = ["#2563eb", "#059669", "#7c3aed", "#f59e0b", "#dc2626", "#0891b2", "#db2777"];

const SALES_DATA = {
    "7d":  { labels: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], values: [1120, 980, 1340, 1560, 1890, 2210, 1750] },
    "30d": { labels: ["Wk 1","Wk 2","Wk 3","Wk 4"], values: [7200, 8450, 7890, 9430] },
    "90d": { labels: ["Jul","Aug","Sep"], values: [29800, 33650, 31240] },
};

let salesChart = null;

function formatMoney(n) {
    return "$" + n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function renderSalesChart(range) {
    const data = SALES_DATA[range];
    const ctx = document.getElementById("salesChart").getContext("2d");

    if (salesChart) salesChart.destroy();
    salesChart = new Chart(ctx, {
        type: "line",
        data: {
            labels: data.labels,
            datasets: [{
                label: "Revenue",
                data: data.values,
                borderColor: "#2563eb",
                backgroundColor: "rgba(37,99,235,0.08)",
                borderWidth: 2.5,
                pointRadius: 3,
                pointBackgroundColor: "#2563eb",
                tension: 0.35,
                fill: true,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: "#f1f5f9" }, ticks: { callback: v => "$" + v, color: "#64748b", font: { size: 11 } } },
                x: { grid: { display: false }, ticks: { color: "#64748b", font: { size: 11 } } }
            }
        }
    });
}

document.getElementById("rangeTabs").addEventListener("click", (e) => {
    if (e.target.tagName !== "BUTTON") return;
    document.querySelectorAll("#rangeTabs button").forEach(b => b.classList.remove("active"));
    e.target.classList.add("active");
    renderSalesChart(e.target.dataset.range);
});

function groupByCategory(products) {
    const groups = {};
    products.forEach(p => {
        const cat = p.category || "Uncategorized";
        if (!groups[cat]) groups[cat] = [];
        groups[cat].push(p);
    });
    return groups;
}

function renderCategoryChart(products) {
    const groups = groupByCategory(products);
    const labels = Object.keys(groups);
    const totals = labels.map(cat => groups[cat].reduce((s, p) => s + (p.price || 0), 0));

    const ctx = document.getElementById("categoryChart").getContext("2d");
    new Chart(ctx, {
        type: "doughnut",
        data: {
            labels,
            datasets: [{
                data: totals,
                backgroundColor: labels.map((_, i) => PALETTE[i % PALETTE.length]),
                borderWidth: 0,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: "bottom", labels: { color: "#64748b", font: { size: 11 }, boxWidth: 10, padding: 12 } }
            }
        }
    });
}

function renderTopProducts(products) {
    const top = [...products].sort((a, b) => b.price - a.price).slice(0, 6);
    const tbody = document.getElementById("topProductsBody");
    tbody.innerHTML = top.map(p => `
        <tr>
            <td>#${p.id}</td>
            <td><strong>${p.title}</strong></td>
            <td style="color:#16a34a; font-weight:600;">${formatMoney(p.price)}</td>
            <td><span class="category-badge">${p.category}</span></td>
        </tr>
    `).join("");
}

async function init() {
    renderSalesChart("7d");

    try {
        const response = await fetch(`${API_URL}/products/`);
        const products = await response.json();

        if (!Array.isArray(products) || products.length === 0) {
            document.getElementById("topProductsBody").innerHTML =
                `<tr><td colspan="4" class="text-center">No products found.</td></tr>`;
            return;
        }

        renderCategoryChart(products);
        renderTopProducts(products);
    } catch (error) {
        console.error("Error loading report data:", error);
        document.getElementById("topProductsBody").innerHTML =
            `<tr><td colspan="4" class="text-center">Couldn't reach the API at ${API_URL}.</td></tr>`;
    }
}

init();
