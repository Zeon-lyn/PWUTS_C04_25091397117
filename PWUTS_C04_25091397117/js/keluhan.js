function initKeluhanPage(){
 const $body=$("#complaintTableBody");
 function render(){
  const q=($("#complaintSearch").val()||"").toLowerCase().trim(), status=$("#complaintStatusFilter").val();
  const all=getComplaints(); const filtered=all.filter(c=>(!status||c.status===status)&&(`${c.title} ${c.category} ${c.id}`.toLowerCase().includes(q)));
  const counts={total:all.length,wait:all.filter(c=>c.status==="Menunggu Tanggapan").length,process:all.filter(c=>c.status==="Sedang Diproses").length,done:all.filter(c=>c.status==="Selesai").length};
  $("#complaint-summary").html(`<article class="stat-card"><div class="stat-top">Total Keluhan<span class="stat-icon ic-blue"><i class="fa-regular fa-message"></i></span></div><div class="stat-number">${counts.total}</div><div class="stat-note">Seluruh laporan Anda</div></article><article class="stat-card"><div class="stat-top">Menunggu Tanggapan<span class="stat-icon ic-orange"><i class="fa-regular fa-clock"></i></span></div><div class="stat-number">${counts.wait}</div><div class="stat-note">Belum ada tanggapan</div></article><article class="stat-card"><div class="stat-top">Sedang Diproses<span class="stat-icon ic-blue"><i class="fa-solid fa-spinner"></i></span></div><div class="stat-number">${counts.process}</div><div class="stat-note">Dalam penanganan</div></article><article class="stat-card"><div class="stat-top">Selesai Ditangani<span class="stat-icon ic-green"><i class="fa-solid fa-circle-check"></i></span></div><div class="stat-number">${counts.done}</div><div class="stat-note">Laporan terselesaikan</div></article>`);
  $body.html(filtered.map(c=>`<tr><td><strong>${escapeHTML(c.id)}</strong></td><td>${formatDate(c.date)}</td><td>${escapeHTML(c.category)}</td><td><strong>${escapeHTML(c.title)}</strong></td><td>${badge(c.status)}</td><td>${escapeHTML(c.response||"Belum ada tanggapan")}</td><td><button class="btn-outline-custom complaint-detail-btn" data-id="${escapeHTML(c.id)}">Detail</button></td></tr>`).join(""));
  $("#complaintEmpty").toggleClass("is-hidden",filtered.length>0);
  $(".table-wrap").toggleClass("is-hidden",filtered.length===0);
 }
 $("#complaintSearch,#complaintStatusFilter").off("input change").on("input change",render);
 $body.off("click",".complaint-detail-btn").on("click",".complaint-detail-btn",function(){
  const c=getComplaints().find(x=>x.id===$(this).data("id"));if(!c)return;
  $("#complaintDetailBody").html(`<div class="detail-line"><span>Nomor Keluhan</span><strong>${escapeHTML(c.id)}</strong></div><div class="detail-line"><span>Tanggal Pengajuan</span><strong>${formatDate(c.date)}</strong></div><div class="detail-line"><span>Kategori</span><strong>${escapeHTML(c.category)}</strong></div><div class="detail-line"><span>Status</span><strong>${badge(c.status)}</strong></div><div class="space-top space-bottom-small text-bold" style="font-size:12px">${escapeHTML(c.title)}</div><div class="detail-description">${escapeHTML(c.description)}</div><div class="space-top text-bold" style="font-size:11px">Tanggapan Owner</div><p class="space-top-small no-bottom" style="font-size:12px;color:#718096;line-height:1.7">${escapeHTML(c.response||"Belum ada tanggapan dari Owner.")}</p>${c.photo?`<div class="space-top"><div class="text-bold space-bottom-small" style="font-size:11px">Foto pendukung</div><img src="${escapeHTML(c.photo)}" alt="Foto pendukung keluhan" style="display:block;max-width:100%;max-height:320px;border-radius:10px;border:1px solid #e7edf4"></div>`:""}`);
  $("#complaintDetailModal").removeClass("is-hidden").addClass("show");
 });
 $("#complaintTableBody").html('<tr><td colspan="7">Memuat data keluhan dari database...</td></tr>');
 refreshComplaints().done(function(){render();}).fail(function(xhr){
  $("#complaint-summary").empty();
  $("#complaintTableBody").html(`<tr><td colspan="7">${escapeHTML(xhr.responseJSON?.message||"Data keluhan gagal dimuat. Periksa koneksi database.")}</td></tr>`);
 });
}
window.initKeluhanPage=initKeluhanPage;

$(document).on("click", "[data-modal-close]", function(){ $("#complaintDetailModal").removeClass("show").addClass("is-hidden"); });
$(document).on("click", "#complaintDetailModal", function(e){ if(e.target===this) $(this).removeClass("show").addClass("is-hidden"); });
$(document).on("keydown", function(e){ if(e.key==="Escape") $("#complaintDetailModal").removeClass("show").addClass("is-hidden"); });
