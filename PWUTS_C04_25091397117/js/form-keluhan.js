function initFormKeluhan(){
 const form=document.getElementById("complaintForm");if(!form)return;
 $("#residentName").val(DEMO_USER.name);$("#residentRoom").val(DEMO_USER.room);
 const today=new Date();$("#complaintDate").val(`${today.getFullYear()}-${String(today.getMonth()+1).padStart(2,"0")}-${String(today.getDate()).padStart(2,"0")}`);
 $("#formSuccess").addClass("is-hidden").text("");$("[data-error-for]").text("");
 $("#complaintPhoto").off("change").on("change",function(){
  const f=this.files[0];$("#photoPreview").text(f?`${f.name} · ${(f.size/1024/1024).toFixed(2)} MB`:"");
  validatePhoto(f);
 });
 function error(field,message){$(`[data-error-for="${field}"]`).text(message);if(message)$(`#${field}`).addClass("is-invalid");else $(`#${field}`).removeClass("is-invalid");}
 function validatePhoto(file){
  let msg="";if(file){const ext=file.name.split(".").pop().toLowerCase();if(!["jpg","jpeg","png"].includes(ext))msg="Foto harus berformat JPG, JPEG, atau PNG.";else if(file.size>2*1024*1024)msg="Ukuran foto maksimal 2 MB.";}
  error("complaintPhoto",msg);return !msg;
 }
 $("#complaintForm").off("submit").on("submit",function(e){
  e.preventDefault();$("[data-error-for]").text("");$(".is-invalid").removeClass("is-invalid");
  const name=$("#residentName").val().trim(),room=$("#residentRoom").val().trim(),category=$("#complaintCategory").val(),title=$("#complaintTitle").val().trim(),description=$("#complaintDescription").val().trim(),file=$("#complaintPhoto")[0].files[0];
  let valid=true;
  if(!name){error("residentName","Nama penghuni wajib terisi.");valid=false;}
  if(!room){error("residentRoom","Nomor kamar wajib terisi.");valid=false;}
  if(!category){error("complaintCategory","Silakan pilih kategori keluhan.");valid=false;}
  if(!title){error("complaintTitle","Judul keluhan tidak boleh kosong.");valid=false;}
  if(!description){error("complaintDescription","Deskripsi keluhan wajib diisi.");valid=false;}else if(description.length<10){error("complaintDescription","Deskripsi minimal 10 karakter.");valid=false;}
  if(!validatePhoto(file))valid=false;
  if(!valid){const first=document.querySelector(".is-invalid");if(first)first.focus();return;}

  const formData=new FormData();
  formData.append("date",$("#complaintDate").val());
  formData.append("category",category);
  formData.append("title",title);
  formData.append("description",description);
  if(file)formData.append("photo",file);

  const $submit=$(form).find('button[type="submit"]').first();
  const originalText=$submit.html();$submit.prop("disabled",true).text("Menyimpan...");
  $.ajax({
   url:"api/keluhan.php",method:"POST",data:formData,processData:false,contentType:false,dataType:"json"
  }).done(function(result){
   $("#formSuccess").removeClass("is-hidden").text(`${result.message} Nomor keluhan: ${result.id}.`);
   showToast(`Keluhan ${result.id} berhasil disimpan.`);
   refreshComplaints().always(function(){setTimeout(()=>loadPage("keluhan"),900);});
  }).fail(function(xhr){
   const message=xhr.responseJSON?.message||"Keluhan gagal disimpan. Periksa server PHP dan koneksi database.";
   $("#formSuccess").removeClass("is-hidden").text(message);
   $("#formSuccess").addClass("form-server-error");
   showToast("Keluhan gagal disimpan.");
  }).always(function(){
   $submit.prop("disabled",false).html(originalText);
  });
 });
}
window.initFormKeluhan=initFormKeluhan;
