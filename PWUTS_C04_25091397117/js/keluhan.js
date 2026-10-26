function initKeluhanPage(){
 const $list=$("#complaintList");
 let activeStatus="",visible=[];
 const STATUS={
  "Menunggu Tanggapan":{cls:"cc-wait",icon:"fa-regular fa-clock",sub:"Belum ada balasan",step:1},
  "Sedang Diproses":{cls:"cc-process",icon:"fa-solid fa-rotate",sub:"Sedang ditangani",step:2},
  "Selesai":{cls:"cc-done",icon:"fa-solid fa-circle-check",sub:"Laporan terselesaikan",step:3},
  "Diterima":{cls:"cc-done",icon:"fa-solid fa-circle-check",sub:"Laporan diterima",step:3},
  "Ditolak":{cls:"cc-reject",icon:"fa-solid fa-circle-xmark",sub:"Laporan ditolak",step:0}
 };
 const metaOf=s=>STATUS[s]||STATUS["Menunggu Tanggapan"];
 function steps(n){
  if(!n)return "";
  return ["Dikirim","Diproses","Selesai"].map((t,i)=>(i?`<span class="cc-line${n>i?" done":""}"></span>`:"")+`<span class="cc-step${n>i?" done":""}"><span class="cc-dot"></span>${t}</span>`).join("");
 }
 function card(c,i){
  const m=metaOf(c.status);
  return `<button type="button" class="complaint-card" data-index="${i}"><span class="cc-status ${m.cls}"><span class="cc-ico"><i class="${m.icon}"></i></span><span><strong>${escapeHTML(c.status)}</strong><small>${c.response?"Sudah ada balasan":m.sub}</small></span></span><span class="cc-body"><span><span class="cc-meta">${escapeHTML(c.id)} · ${escapeHTML(c.category)} · ${formatDate(c.date)}</span><span class="cc-title">${escapeHTML(c.title)}</span></span><span class="cc-steps">${steps(m.step)}</span></span><span class="cc-go"><i class="fa-solid fa-chevron-right"></i></span></button>`;
 }
 function render(){
  const q=($("#complaintSearch").val()||"").toLowerCase().trim();
  const all=getComplaints().sort((a,b)=>String(b.date).localeCompare(String(a.date)));
  const count=s=>s?all.filter(c=>c.status===s).length:all.length;
  $(".tab").each(function(){$(this).find(".tab-count").text(count($(this).data("status")));});
  visible=all.filter(c=>(!activeStatus||c.status===activeStatus)&&(`${c.title} ${c.category} ${c.id}`.toLowerCase().includes(q)));
  $list.html(visible.map(card).join(""));
  $("#complaintEmpty").toggleClass("is-hidden",visible.length>0);
  $("#complaintCount").text(visible.length?`Menampilkan ${visible.length} dari ${all.length} keluhan`:"");
 }
 $("#complaintSearch").off("input").on("input",render);
 $(".tab").off("click").on("click",function(){
  activeStatus=$(this).data("status")||"";
  $(".tab").removeClass("active").attr("aria-pressed","false");
  $(this).addClass("active").attr("aria-pressed","true");
  render();
 });
 $list.off("click",".complaint-card").on("click",".complaint-card",function(){
  const c=visible[Number($(this).data("index"))];if(!c)return;
  $("#complaintDetailBody").html(`<div class="detail-line"><span>Nomor Keluhan</span><strong>${escapeHTML(c.id)}</strong></div><div class="detail-line"><span>Tanggal Pengajuan</span><strong>${formatDate(c.date)}</strong></div><div class="detail-line"><span>Kategori</span><strong>${escapeHTML(c.category)}</strong></div><div class="detail-line"><span>Status</span><strong>${badge(c.status)}</strong></div><div class="space-top space-bottom-small text-bold" style="font-size:12px">${escapeHTML(c.title)}</div><div class="detail-description">${escapeHTML(c.description)}</div><div class="space-top text-bold" style="font-size:11px">Tanggapan Owner</div><p class="space-top-small no-bottom" style="font-size:12px;color:#718096;line-height:1.7">${escapeHTML(c.response||"Belum ada tanggapan dari Owner.")}</p>${c.photo?`<div class="space-top"><div class="text-bold space-bottom-small" style="font-size:11px">Foto pendukung</div><img src="${escapeHTML(c.photo)}" alt="Foto pendukung keluhan" style="display:block;max-width:100%;max-height:320px;border-radius:10px;border:1px solid #e7edf4"></div>`:""}`);
  $("#complaintDetailModal").removeClass("is-hidden").addClass("show");
 });
 $list.html('<div class="loading-state"><div class="loading-spinner"></div><p>Memuat data keluhan dari database...</p></div>');
 refreshComplaints().done(render).fail(function(xhr){
  $list.html(`<section class="panel"><p>${escapeHTML(xhr.responseJSON?.message||"Data keluhan gagal dimuat. Periksa koneksi database.")}</p></section>`);
 });
}
window.initKeluhanPage=initKeluhanPage;

$(document).on("click","[data-modal-close]",function(){$("#complaintDetailModal").removeClass("show").addClass("is-hidden");});
$(document).on("click","#complaintDetailModal",function(e){if(e.target===this)$(this).removeClass("show").addClass("is-hidden");});
$(document).on("keydown",function(e){if(e.key==="Escape")$("#complaintDetailModal").removeClass("show").addClass("is-hidden");});
