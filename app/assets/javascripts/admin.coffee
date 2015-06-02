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
					location.load("/admin/main")
	bind_ajax()

$(".admin.delete_data").ready ->
	bind_ajax2 = () ->
		$("#delete_result_btn").unbind("click").click ->
			$.ajax
				type: "get"
				url: "/admin/delete_data"
				data: {
					
					delete_name: $("#delete_name").val()
					delete_company: $("#delete_company").val()
				}
				dataType: "json"
				success: (data,status) ->
					if(data["error_delete_Scholar_list"] == 0)
						alert("Delete Scholar_list Success")
					else
						alert("Fail Scholar_list")

					if(data["error_delete_Scholar_cond"] == 0)
						alert("Delete Scholar_cond Success")
					else
						alert("Fail Scholar_cond")

					if(data["error_delete_Region_list"] == 0)
						alert("Delete Scholar_Region Success")
					else
						alert("Fail Scholar_Region")

					if(data["error_delete_Major_list"] == 0)
						alert("Delete Major_list Success")
					else
						alert("Fail Major_list")
					
					if(data["error_delete_Document"] == 0)
						alert("Delete Document Success")
					else
						alert("Fail Document")
	
					if(data["error_delete_Past_Result"] == 0)
						alert("Delete Past_Result Success")
					else
						alert("Fail Past_Result")
					location.load("/admin/main")
	
	bind_ajax2()

$(".admin.update_data").ready ->
	bind_ajax2 = () ->
		$("#update_result_btn").unbind("click").click ->
			$.ajax
				type: "get"
				url: "/admin/update_data"
				data: {
					
					ori_name: $("#ori_name").val()
					ori_company: $("#ori_company").val()
					update_amount: $("#update_amount").val()
					update_number: $("#update_number").val()
					update_applystart: $("#update_applystart").val()
					update_applyend: $("#update_applyend").val()
					update_homepage: $("#update_homepage").val()
					update_gpa: $("#update_gpa").val()
					update_region: $("#update_region").val()
					update_major: $("select[name=update_major]").val()
					update_uni: $("input:radio[name=update_uni]:checked").val()
					update_income: $("input:radio[name=update_income]:checked").val()
				}
				dataType: "json"
				success: (data,status) ->
					if(data["error_1"] == 0)
						alert("update Scholar_list Success")
					else
						alert("Fail Scholar_list")

					if(data["error_2"] == 0)
						alert("update Scholar_cond Success")
					else
						alert("Fail Scholar_cond")
					if(data["error_3"] == 0)
						alert("update Region_list Success")
					else
						alert("Fail Region_list")
					if(data["error_4"] == 0)
						alert("update Major_list Success")
					else
						alert("Fail Major_list")
			

	
	bind_ajax2()
