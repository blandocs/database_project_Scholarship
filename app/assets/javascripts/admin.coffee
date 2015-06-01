# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(".admin.insert_data").ready ->
	bind_ajax = () ->
		$("#insert_result_btn").unbind("click").click ->
			$.ajax
				type: "get"
				url: "/admin/insert_data"
				data: {
					
					admin_name: $("#admin_name").val()
					admin_company: $("#admin_company").val()
					admin_amount: $("#admin_amount").val()
					admin_number: $("#admin_number").val()
					admin_applystart: $("#admin_applystart").val()
					admin_applyend: $("#admin_applyend").val()
					admin_homepage: $("#admin_homepage").val()
					admin_gpa: $("#admin_gpa").val()
					admin_region: $("#admin_region").val()
					admin_major: $("select[name=admin_major]").val()
					admin_uni: $("input:radio[name=admin_uni]:checked").val()
					admin_income: $("input:radio[name=admin_income]:checked").val()
				}
				dataType: "json"
				success: (data,status) ->
					if(data["error_Scholar_list"] == 0)
						alert("Insert Scholar_list Success")
					else
						alert("Fail Scholar_list")

					if(data["error_Scholar_cond"] == 0)
						alert("Insert Scholar_cond Success")
					else
						alert("Fail Scholar_cond")

					if(data["error_Region_list"] == 0)
						alert("Insert Scholar_Region Success")
					else
						alert("Fail Scholar_Region")

					if(data["error_Major_list"] == 0)
						alert("Insert Major_list Success")
					else
						alert("Fail Major_list")

	bind_ajax()
