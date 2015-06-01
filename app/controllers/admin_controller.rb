class AdminController < ApplicationController
  def main
  end

	def insert_data
		
		@error_Scholar_list = 0 
		sql1 = "insert into Scholar_list (Name, Company, Amount, Number, ApplyStart, ApplyEnd, Homepage) values ( "	+ "'"	+ params[:admin_name] + "'," 	+	"'"+ params[:admin_company] + "'," 	+ params[:admin_amount] + "," 	+	params[:admin_number] + "," +	"'"+ params[:admin_applystart] + "'," +	"'"+ params[:admin_applyend] + "'," +	"'"+ params[:admin_homepage] + "')"
		begin
		  ActiveRecord::Base.connection.execute(sql1)
		rescue
			@error_Scholar_list = 1
		end

		@error_Scholar_cond = 0 
		sql2 = "insert into Scholar_cond (ID, GPA, Income, TypeofUniversity) (select ID, " + params[:admin_gpa].to_s + "," + params[:admin_income].to_s + "," + params[:admin_uni].to_s + " from Scholar_list where Name = '" + params[:admin_name].to_s + "' and Company = '" + params[:admin_company].to_s + "')"

		begin
		  ActiveRecord::Base.connection.execute(sql2)
		rescue
			@error_Scholar_cond = 1
		end

		@error_Region_list = 0 
		sql3= "insert into Region_list (ID, Region) (select ID," + "'" + params[:admin_region] + "'" + " from Scholar_list where Name =" + "'" + params[:admin_name] + "' and Company =" + "'" + params[:admin_company] + "')"
		
		begin
		  ActiveRecord::Base.connection.execute(sql3)
		rescue
			@error_Region_list = 1
		end

		@error_Major_list = 0

		sql4 = "insert into Major_list (ID, Major) (select ID," + "'" + params[:admin_major].to_s + "' from Scholar_list where Name=" + "'" + params[:admin_name] + "' and Company =" + "'" + params[:admin_company] + "')" 

		begin
		  ActiveRecord::Base.connection.execute(sql4)
		rescue
			@error_Major_list = 1
		end
	

		render json: {error_Scholar_list: @error_Scholar_list, error_Scholar_cond: @error_Scholar_cond, error_Region_list: @error_Region_list, error_Major_list: @error_Major_list}


	end

	def delete_data
		
		@error_delete_Scholar_cond = 0
		sql2 = "delete from Scholar_cond where ID = (select ID from Scholar_list where Name = " + "'" + params[:delete_name] + "' and Company = '" + params[:delete_company]  + "')"
		begin
		  ActiveRecord::Base.connection.execute(sql2)
		rescue
			@error_delete_Scholar_cond = 1
		end

		@error_delete_Region_list = 0 
		sql3 = "delete from Region_list where ID = (select ID from Scholar_list where Name = " + "'" + params[:delete_name] + "' and Company = '" + params[:delete_company] + "')"
		begin
		  ActiveRecord::Base.connection.execute(sql3)
		rescue
			@error_delete_Region_list = 1
		end

		@error_delete_Major_list = 0 
		sql4 = "delete from Major_list where ID = (select ID from Scholar_list where Name = " + "'" + params[:delete_name] + "' and Company = '" + params[:delete_company] + "')"
		begin
		  ActiveRecord::Base.connection.execute(sql4)
		rescue
			@error_delete_Major_list = 1
		end
		
		sql5 = "delete from Document where ID = (select ID from Scholar_list where Name = " + "'" + params[:delete_name] + "' and Company = '" + params[:delete_company] + "')"

		@error_delete_Document = 0
		begin
		  ActiveRecord::Base.connection.execute(sql5)
		rescue
			@error_delete_Document = 1
		end

		sql6 = "delete from Past_Result where ID = (select ID from Scholar_list where Name = " + "'" + params[:delete_name]  + "' and Company = '" + params[:delete_company] + "')"
		@error_delete_Past_Result = 0
		begin
		  ActiveRecord::Base.connection.execute(sql5)
		rescue
			@error_delete_Past_Result = 1
		end

		sql1 = "delete from Scholar_list where Name = '" + params[:delete_name] + "' and Company = '" + params[:delete_company] + "'"
		
		@error_delete_Scholar_list = 0
		begin
		  ActiveRecord::Base.connection.execute(sql5)
		rescue
			@error_delete_Scholar_list = 1
		end
	
		render json: {error_delete_Scholar_list: @error_delete_Scholar_list, error_delete_Scholar_cond: @error_delete_Scholar_cond, error_delete_Region_list: @error_delete_Region_list, error_delete_Major_list: @error_delete_Major_list, error_delete_Document: @error_delete_Document, error_delete_Past_Result: @error_delete_Past_Result}
		
	end

	def update_data

	end

end
