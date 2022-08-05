let form_last_visit_submitters = document.querySelectorAll('form > div.btn-like-success')
let form_delet_submitters = document.querySelectorAll('form > div.btn-like-danger')

for (var i = form_last_visit_submitters.length; i--;) {
  form_last_visit_submitters[i].addEventListener('click', (e) => handle_submit_visit(e))
  form_delet_submitters[i].addEventListener('click', (e) => handle_delete_site(e))
}

const handle_submit_visit = (e) => {
  site_name = e.currentTarget.getAttribute('site_name')
  if (window.confirm(`هل تود تحديث تاريخ اخر زيارة للموقع ${site_name} بتاريخ اليوم`))
    e.currentTarget.parentNode.submit()
}

const handle_delete_site = (e) => {
  site_name = e.currentTarget.getAttribute('site_name')
  if (window.confirm(`هل تود حذف الموقع ${site_name}؟ٍ`))
    e.currentTarget.parentNode.submit()
}

