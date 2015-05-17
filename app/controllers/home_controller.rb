class HomeController < ApplicationController
  def main
  end

	def list_scholarship
		sql = "select * from Scholar_list order by Year, Semester"
			@i = 0
			@scholar = []
		ActiveRecord::Base.connection.execute(sql).each do |row|
			@scholar[@i] = row
			@i = @i + 1
		end

	end
end
