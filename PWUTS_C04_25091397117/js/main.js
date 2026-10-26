/* Website Kelola Kost — fitur keluhan terhubung ke PHP/MySQL melalui AJAX. */
const DEMO_USER={name:"Andi Pratama",room:"103",kost:"Kost Melati",phone:"082333333333",city:"Jember",email:"",rent:900000};
let serverComplaints=[];
let apiUser={...DEMO_USER};
function getComplaints(){return serverComplaints.slice();}
function saveComplaints(items){serverComplaints=Array.isArray(items)?items:[];}
function refreshComplaints(){return $.getJSON("api/keluhan.php").then(function(result){if(!result.success)throw new Error(result.message||"Gagal memuat data.");// API sudah menggunakan SELECT DISTINCT; jangan deduplikasi berdasarkan ID di browser karena ID kosong/0 yang berulang bisa menghilangkan laporan yang berbeda.
serverComplaints=Array.isArray(result.data)?result.data:[];if(result.user){Object.assign(apiUser,result.user);Object.assign(DEMO_USER,result.user);}return result;});}
function escapeHTML(value){return String(value??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));}
function formatDate(date){if(!date)return "—";return new Date(date+"T00:00:00").toLocaleDateString("id-ID",{day:"2-digit",month:"long",year:"numeric"});}
function statusClass(status){if(status==="Selesai"||status==="Diterima")return "status-done";if(status==="Sedang Diproses")return "status-process";if(status==="Ditolak")return "status-reject";return "status-wait";}
function badge(status){return `<span class="status-badge ${statusClass(status)}"><i class="fa-solid fa-circle" style="font-size:5px"></i>${escapeHTML(status)}</span>`;}
let toastTimer;
function showToast(message){$("#toastMessage").text(message);$("#appToast").addClass("show");clearTimeout(toastTimer);toastTimer=setTimeout(()=>$("#appToast").removeClass("show"),3200);}
$(document).on("click","#toastClose",()=>$("#appToast").removeClass("show"));
const TITLES={dashboard:"Dashboard",profil:"Profil Saya",kamar:"Informasi Kamar",pembayaran:"Pembayaran",riwayat:"Riwayat Pembayaran",pengumuman:"Pengumuman",keluhan:"Keluhan Saya","form-keluhan":"Ajukan Keluhan",berhenti:"Berhenti Ngekos"};
function setActive(page){$(".side-nav .nav-link").removeClass("active");$(`.side-nav .nav-link[data-page="${page}"]`).addClass("active");$("#currentSection").text(TITLES[page]||"Dashboard");}
function loadPage(page){setActive(page);$("#sidebar").removeClass("open");$("#sidebarBackdrop").removeClass("show");
 if(page==="dashboard"){renderDashboard();return;}
 if(page==="keluhan"||page==="form-keluhan"){$("#main-content").html('<div class="loading-state"><div class="loading-spinner"></div><p>Memuat halaman...</p></div>');const path=page==="keluhan"?"keluhan.html":"form-keluhan.html";$("#main-content").load(path,function(response,status){if(status==="error"){$("#main-content").html('<section class="panel"><h3>Halaman tidak dapat dimuat</h3><p>Jalankan website menggunakan VS Code Live Server atau Apache XAMPP.</p></section>');return;}if(page==="keluhan"&&window.initKeluhanPage)window.initKeluhanPage();if(page==="form-keluhan"&&window.initFormKeluhan)window.initFormKeluhan();});return;}
 $("#main-content").html(`<div class="page-heading"><div><div class="eyebrow">MENU PENGHUNI</div><h1>${escapeHTML(TITLES[page]||"Menu")}</h1><p>Halaman ini menyediakan informasi terkait fitur pengelolaan kost bagi penghuni.</p></div></div><section class="panel"><div class="empty-state"><i class="fa-solid fa-screwdriver-wrench icon-block"></i><strong>Informasi Segera Hadir</strong><p>Informasi untuk menu ini akan tersedia pada pengembangan selanjutnya. Terima kasih atas pengertian Anda.</p><button class="btn-primary-custom space-top" data-page="keluhan"><i class="fa-regular fa-message"></i>Buka Keluhan</button></div></section>`);
}
function renderDashboard(){
 $("#main-content").html('<div class="loading-state"><div class="loading-spinner"></div><p>Memuat ringkasan dari database...</p></div>');
 refreshComplaints().done(function(){
  const complaints=getComplaints(),open=complaints.filter(c=>c.status!=="Selesai").length,latest=complaints.slice().sort((a,b)=>b.date.localeCompare(a.date)).slice(0,3);
  $("#main-content").html(`<div class="page-heading"><div><div class="eyebrow">PORTAL PENGHUNI</div><h1>Dashboard</h1><p>Ringkasan fitur keluhan penghuni kost.</p></div><div class="date-chip"><i class="fa-regular fa-calendar space-right"></i>${new Date().toLocaleDateString("id-ID",{day:"2-digit",month:"long",year:"numeric"})}</div></div><section class="stats-grid" style="grid-template-columns:repeat(auto-fit,minmax(210px,1fr))"><article class="stat-card"><div class="stat-top">Total Keluhan<span class="stat-icon ic-blue"><i class="fa-regular fa-message"></i></span></div><div class="stat-number">${complaints.length}</div><div class="stat-note">Semua laporan Anda dari database</div></article><article class="stat-card"><div class="stat-top">Keluhan Aktif<span class="stat-icon ic-orange"><i class="fa-regular fa-clock"></i></span></div><div class="stat-number">${open}</div><div class="stat-note">Belum selesai ditangani</div></article></section><section class="panel"><div class="panel-heading"><div><h3>Keluhan Terbaru</h3><p>Pantau laporan yang telah Anda kirim</p></div><button class="text-link" data-page="keluhan">Semua keluhan <i class="fa-solid fa-arrow-right space-left"></i></button></div>${latest.length?latest.map(c=>`<div class="complaint-item"><span class="complaint-marker" style="background:${c.status==="Selesai"?"#20a477":c.status==="Sedang Diproses"?"#3477df":"#e7a42b"}"></span><div style="flex:1"><strong>${escapeHTML(c.title)}</strong><p>${escapeHTML(c.id)} · ${formatDate(c.date)}</p></div>${badge(c.status)}</div>`).join(""):'<div class="empty-state"><strong>Belum ada keluhan</strong></div>'}<div class="space-top"><button class="btn-primary-custom" data-page="form-keluhan"><i class="fa-solid fa-plus"></i>Ajukan Keluhan</button></div></section>`);
 }).fail(function(xhr){
  const msg=xhr.responseJSON?.message||"Pastikan Apache dan MySQL aktif, lalu impor database/db_kelola_kost.sql.";
  $("#main-content").html(`<section class="panel"><h3>Database belum dapat diakses</h3><p>${escapeHTML(msg)}</p><p>Jalankan proyek melalui XAMPP/Apache, bukan Live Server, dan periksa api/config.php.</p></section>`);
 });
}
$(document).on("click","[data-page]",function(e){e.preventDefault();loadPage($(this).data("page"));});
$(document).on("click","#mobileMenu",()=>{$("#sidebar").addClass("open");$("#sidebarBackdrop").addClass("show");});$(document).on("click","#sidebarBackdrop",()=>{$("#sidebar").removeClass("open");$("#sidebarBackdrop").removeClass("show");});
$(document).on("click","#logoutBtn",function(e){e.preventDefault();if(confirm("Keluar dari portal simulasi penghuni?"))showToast("Ini adalah simulasi. Tidak ada sesi server yang sedang aktif.");});$(document).on("click","#notificationBtn",()=>showToast("Tidak ada notifikasi baru."));$(document).on("click","#resetFormBtn",function(){if(confirm("Kosongkan semua isian formulir?"))$("#complaintForm")[0]?.reset();});
$(document).ready(()=>renderDashboard());
window.loadPage=loadPage;window.getComplaints=getComplaints;window.saveComplaints=saveComplaints;window.refreshComplaints=refreshComplaints;window.DEMO_USER=DEMO_USER;window.escapeHTML=escapeHTML;window.formatDate=formatDate;window.statusClass=statusClass;window.badge=badge;window.showToast=showToast;
