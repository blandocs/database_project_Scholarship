class HomeController < ApplicationController

	def main
  	
	end


	def simple_search
		sql = "select * from Scholar_list natural join Scholar_cond where "	
		if(params[:university] == "0")
			sql +=  "(TypeofUniversity %4) >= 2"
		elsif(params[:university] = "1")
			sql += "TypeofUniversity >=4"
		elsif(params[:university] == "2")
			sql += "(TypeofUniversity %2) = 1"
		else 
			sql += "Amount > 500"
		end

		if(params[:income] == "0")
			sql +=  " and Income %2 = 1"
		elsif(params[:income] == "1")
			sql += " and Income %4 >= 2"
		elsif(params[:income] == "2")
			sql += " and Income >= 4"
		end

		result = ActiveRecord::Base.connection.execute(sql)
		render json: {querydata: result}
	
	end

	def hard_search
		sql = "select * from Scholar_list natural join Scholar_cond natural join Major_list where "
		
		if(params[:university] == "0")
			sql +=  "(TypeofUniversity %4) >= 2"
		elsif(params[:university] = "1")
			sql += "TypeofUniversity >=4"
		elsif(params[:university] == "2")
			sql += "(TypeofUniversity %2) = 1"
		end

		if(params[:income] == "0")
			sql +=  " and Income %2 = 1"
		elsif(params[:income] == "1")
			sql += " and Income %4 >= 2"
		elsif(params[:income] == "2")
			sql += " and Income >= 4"
		end

		if(params[:major] == "0")
			sql += " and Major = '공학계열'"
		elsif(params[:major] == "1")
			sql += " and Major = '법학계열'"
		elsif(params[:major] == "2")
			sql += " and Major = '사범계열'"
		
		elsif(params[:major] == "3")
			sql += " and Major = '사회과학계열'"
		
		elsif(params[:major] == "4")
			sql += " and Major = '예체능계열'"
		
		elsif(params[:major] == "5")
			sql += " and Major = '약학계열'"
		
		elsif(params[:major] == "6")
			sql += " and Major = '의학계열'"
		
		elsif(params[:major] == "7")
			sql += " and Major = '인문학계열'"
		
		elsif(params[:major] == "8")
			sql += " and Major = '자연과학계열'"
		
		elsif(params[:major] == "9")
			sql += " and Major = '기타'"
		else
			sql += " and Amount > 1"
		end

		sql += " and " + params[:gpa] + " >= GPA"
		
		if(params[:available] == "0")
			sql += " and (ApplyStart is null or (ApplyStart <= curdate() and ApplyEnd >= curdate()))"
		else
			sql += " and (ApplyStart is not null or (ApplyStart > curdate() or ApplyEnd < curdate()))"
		end

		sql += " and Amount >= " + params[:min_price]
		
		result = ActiveRecord::Base.connection.execute(sql)
		render json: {querydata: result}

	end




	def predict

			
		def checkFit(inX, conditionVector)
			 for i in (0..1)
					if conditionVector[i]==nil
						 next
					elsif inX[i] < conditionVector[i] 
						 return 0
					end
			 end

			 for i in (2..3)
					if conditionVector[i]==nil
						 next
					elsif inX[i]&conditionVector[i]!=inX[i]
						 return 0
					end
			 end

			 #if inX[4] != conditionVector[4]
			 #   return 0
			 #end

			 return inX[0..2]
		end

		#(1*N)array->(1*N)matrix
		def array2Nmatrix(inX)
			 size=inX.length

			 new_inX=N.new(size).slice(0, 0..(size-1))
			 for i in (0..(size-1))
					new_inX[i]=inX[i]
			 end

			 return new_inX
		end

		#matrix*int->matrix
		#mat's type is nmatrix
		#row is int
		def tile(mat, row)
			 size = mat.shape[1]
			 returnMat = N.new(row).slice(0..(row-1), 0..(size-1))

			 for i in (0..row-1)
					for j in (0..size-1)
						 returnMat[i, j] = mat[j]
					end
			 end

			 return returnMat
		end

		#matrix*matrix*matrix*int->float
		#dataSet is (# of people)*3 matrix
		#labels is (# of people)-D vector
		#inX's type is 3-D vector which is 
		#implemented by nmatrix(grade, credit, income)
		def classify0(inX, dataSet, labels, k)
			 size = inX.shape[1]
			 dataSetSize = dataSet.shape[0]
			 diffMat = tile(inX, dataSetSize) - dataSet
			 sqDiffMat = diffMat**2
			 sqDistances = sqDiffMat.sum(1)#row sum
			 distances = sqDistances**0.5
			 sortedDistIndicies = distances.sorted_indices()

			 votelable = 0
			 #take vote to lowest distances
			 for i in (0..k-1)
					votelable +=  labels[sortedDistIndicies[i]]
			 end

			 return votelable/k.to_f
		end

		#matrix->matrx*matrix*matrix
		def autoNorm(dataSet)
			 minVals = dataSet.min()
			 maxVals = dataSet.max()
			 ranges = maxVals-minVals
			 normDataSet = N.zeros(dataSet.shape)
			 m = dataSet.shape[0]
			 normDataSet = dataSet - tile(minVals, m)
			 normDataSet = normDataSet / tile(ranges, m)

			 return normDataSet, ranges, minVals
		end

		#string->matrix*matrix
		#should be seperated by hard tab 
		def file2matrix(filename)
			 fr = File.open(filename, "r")
			 numberOfLines = fr.readlines.size#numberOfLines==number of people
			 returnMat = N.zeros([numberOfLines, 3])
			 passLabelVector = N.new(numberOfLines).slice(0, 0..(numberOfLines-1))
			 fr = File.open(filename, "r")
			 index = 0

			 for line in fr.readlines
					line = line.strip!
					listFromLine = line.split("\t")
					for i in (0..2)
						 returnMat[index, i] = listFromLine[i].to_f
					end
					passLabelVector[index] = listFromLine[-1].to_i
					index=index+1
			 end

			 return returnMat, passLabelVector
		end

		#list of list->matrix*matrix
		#should be seperated by hard tab 
		#column(grade, credits, income, typeOfUniv, major, pass)
		def result2matrix(result)
			 numberOfRows = result.length
			 returnMat = N.zeros([numberOfRows, 3])
			 passLabelVector = N.new(numberOfRows).slice(0, 0..(numberOfRows-1))

			 for index in (0..numberOfRows-1)
					row = result[index]
					for i in (0..2)
						 returnMat[index, i] = row[i].to_f
					end
					passLabelVector[index] = row[-1].to_i
			 end

			 return returnMat, passLabelVector
		end


		#array*string*array->float
		#input:5-D Array(grade, credits, income, typeOfUniv, major)
		#result: list of list
		#conditionVector: 5-D Array(grade, credits, income, typeOfUniv, major)


		def classifyPerson(conditionVector, result, input)
			 eval('DataMatXLabels = result2matrix(result)')#string->matrix*matrix
			 eval('DataMat = DataMatXLabels[0]')#matrix
			 eval('Labels = DataMatXLabels[1]')#matrix

			 normMatXrangesXminVals = autoNorm(DataMat)#matrix->matrix*matrix*matrix
			 normMat = normMatXrangesXminVals[0]#matrix
			 ranges = normMatXrangesXminVals[1]#matrix
			 minVals = normMatXrangesXminVals[2]#matrix

			 inX = checkFit(input, conditionVector)#array*array->array
			 if(inX!=0)
					inX = array2Nmatrix(inX)#array->matrix
					inArr = (inX-minVals)/ranges#matrix
					#matrix*matrix*array*int->float
					classifierResult = classify0(inArr, normMat, Labels, 9)
			 else
					classifierResult=0.0
			 end

			 puts classifierResult
			 return classifierResult#float
		end


		sql = "select GPA, 130, Income, TypeofUniversity, 'empty'  from Scholar_list natural join Scholar_cond where ID = " + params[:scholar_id]
		
		cv = ActiveRecord::Base.connection.execute(sql)
		
		@cv1

		cv.each do |row|
			@cv1 = row
		end
	
		sql2 = "select GPA, Credit, Income, TypeOfUniversity, Major, Pass  from Past_Result where ID = " + params[:scholar_id]
		
		result = ActiveRecord::Base.connection.execute(sql2)
	
		@result_list = []
		
		result.each do |row|
			if row[0] = row[0].to_f
			@result_list = @result_list + [row]
			end
		end
		input = [params[:gpa].to_f, params[:credit].to_i, params[:income].to_i, params[:university].to_i, params[:major]]
		
		poss = classifyPerson(@cv1, @result_list, input)
		render json: {possibility: poss}
	
	end

end
