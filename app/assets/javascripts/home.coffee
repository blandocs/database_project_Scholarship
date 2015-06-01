$(".home.main").ready ->
	$('#simple_search_btn').click ->
		$("#main_view").hide()
		$("#hard_view").hide()
		$("#poss_view").hide()
		$("#simple_view").show()
		$("#simple_main").show()
		$("#simple_result").hide()
	
	$("#hard_search_btn").click ->
		$("#main_view").hide()
		$("#hard_view").show()
		$("#poss_view").hide()
		$("#simple_view").hide()

	$("#possibility_btn").click ->
		$("#main_view").hide()
		$("#hard_view").hide()
		$("#poss_view").show()
		$("#simple_view").hide()
	
	
$(".home.simple_search").ready ->
	bind_ajax = () ->
		$("#simple_result_btn").unbind("click").click ->
			$.ajax
				type: "get"
				url: "/home/simple_search"
				data: {
					university: $("input:radio[name=university]:checked").val()
					income: $("input:radio[name=income]:checked").val()

				}
				dataType: "json"
				success: (data,status) ->
					$("#simple_main").hide()
					$("#simple_result").show()
					i = 0
					len = data["querydata"].length
					while i < len
						$('#simple_table').append('<tr>' + '<th><center>'+ data["querydata"][i][0] + '</center></th>'+ '<th><center>' + data["querydata"][i][1] + '</center></th>'+'<th><center>' + data["querydata"][i][2] + '</center></th>' + '<th><center>'+ data["querydata"][i][3] + '</center></th>' + '<th><center>' + data["querydata"][i][4] + '</center></th>' + '<th><center>' + data["querydata"][i][5] + '</center></th>' + '<th><center>' + data["querydata"][i][6] + '</center></th>' + '<th><center>'+ data["querydata"][i][7] + '</center></th>' + '</tr>')
						i++
	bind_ajax()

$(".home.hard_search").ready ->
	bind_ajax2 = () ->
		$("#hard_result_btn").unbind("click").click ->
			$.ajax
				type: "get"
				url: "/home/hard_search"
				data: {
					university: $("input:radio[name=university]:checked").val()
					income: $("input:radio[name=income]:checked").val()
					major: $("select[name=major]").val()
					gpa: $("#gpa").val()
					available: $("input:radio[name=available]:checked").val()
					min_price: $("#min_price").val()
					
				}
				dataType: "json"
				success: (data,status) ->
					$("#hard_main").hide()
					$("#hard_result").show()
					i = 0
					len = data["querydata"].length
					while i < len
						$('#hard_table').append('<tr>' + '<th><center>'+ data["querydata"][i][0] + '</center></th>'+ '<th><center>' + data["querydata"][i][1] + '</center></th>'+'<th><center>' + data["querydata"][i][2] + '</center></th>' + '<th><center>'+ data["querydata"][i][3] + '</center></th>' + '<th><center>' + data["querydata"][i][4] + '</center></th>' + '<th><center>' + data["querydata"][i][5] + '</center></th>' + '<th><center>' + data["querydata"][i][6] + '</center></th>' + '<th><center>'+ data["querydata"][i][7] + '</center></th>' + '</tr>')
						i++
	bind_ajax2()

$(".home.predict").ready ->
	bind_ajax3 = () ->
		$("#poss_result_btn").unbind("click").click ->
			$.ajax
				type: "get"
				url: "/home/predict"
				data: {
					university: $("input:radio[name=university_2]:checked").val()
					income: $("input:radio[name=income_2]:checked").val()
					major: $("select[name=major_2]").val()
					gpa: $("#gpa_2").val()
					credit: $("#credit").val()
					scholar_id: $("#scholar_id").val()
				}
				dataType: "json"
				success: (data,status) ->
					alert("이 장학금에 붙을 확률은 " + data["possibility"] + "입니다")
	bind_ajax3()
