importance <- function(mytree) {
	
	# Calculate variable importance for an rpart classification tree
	
	# NOTE!! The tree *must* be based upon data that has the response (a factor)
	#        in the *first* column

	# Returns an object of class 'importance.rpart'
	
	# You can use print() and summary() to find information on the result
	
	delta_i <- function(data,variable,value) {
		# Calculate the decrease in impurity at a particular node given:
		
		#  data -- the subset of the data that 'reaches' a particular node
		#  variable -- the variable to be used to split the data
		#  value -- the 'split value' for the variable

		current_gini <- gini(data[,1])
		size <- length(data[,1])
		left_dataset <- eval(parse(text=paste("subset(data,",paste(variable,"<",value),")")))
		size_left <- length(left_dataset[,1])
		left_gini <- gini(left_dataset[,1])
		right_dataset <- eval(parse(text=paste("subset(data,",paste(variable,">=",value),")")))
		size_right <- length(right_dataset[,1])
		right_gini <- gini(right_dataset[,1])
		# print(paste("     Gini values: current=",current_gini,"(size=",size,") left=",left_gini,"(size=",size_left,"), right=", right_gini,"(size=",size_right,")"))
		current_gini*size-length(left_dataset[,1])*left_gini-length(right_dataset[,1])*right_gini
		}
		
	gini <- function(data) {
		# Calculate the gini value for a vector of categorical data
		numFactors = nlevels(data)
		nameFactors = levels(data)
		proportion = rep(0,numFactors)
		for (i in 1:numFactors) {
			proportion[i] = sum(data==nameFactors[i])/length(data)
			}
		1-sum(proportion**2)
		}
		
	frame <- mytree$frame
	splits <- mytree$splits
	allData <- eval(mytree$call$data)

	output <- ""
	finalAnswer <- rep(0,length(names(allData)))
	names(finalAnswer) <- names(allData)
	
	d <- dimnames(frame)[[1]]
	# Make this vector of length = the max nodeID
	# It will be a lookup table from frame-->splits
	index <- rep(0,as.integer(d[length(d)]))
	total <- 1
	for (node in 1:length(frame[,1])) {
		if (frame[node,]$var!="<leaf>") {
			nodeID <- as.integer(d[node])
			index[nodeID] <- total
			total <- total + frame[node,]$ncompete + frame[node,]$nsurrogate+ 1
			}
		}
	
	for (node in 1:length(frame[,1])) {
		if (frame[node,]$var!="<leaf>") {
			nodeID <- as.integer(d[node])
			output <- paste(output,"Looking at nodeID:",nodeID,"\n")
			output <- paste(output," (1) Need to find subset","\n")
			output <- paste(output,"   Choices made to get here:...","\n")
			data <- allData
			if (nodeID%%2==0) symbol <- "<"
			else symbol <- ">="
			i <- nodeID%/%2
			while (i>0) {
				output <- paste(output,"    Came from nodeID:",i,"\n")
				variable <- dimnames(splits)[[1]][index[i]]
				value <- splits[index[i],4]
				command <- paste("subset(allData,",variable,symbol,value,")")
				output <- paste(output,"      Applying command",command,"\n")
				data <- eval(parse(text=command))
				if (i%%2==0) symbol <- "<"
				else symbol <- ">="
				i <- i%/%2
				}
			output <- paste(output,"   Size of current subset:",length(data[,1]),"\n")
			
			output <- paste(output," (2) Look at importance of chosen split","\n")
			variable <- dimnames(splits)[[1]][index[nodeID]]	
			value <- splits[index[nodeID],4]
			best_delta_i <- delta_i(data,variable,value)
			output <- paste(output,"   The best delta_i is:",format(best_delta_i,digits=3),"for",variable,"and",value,"\n")
			finalAnswer[variable] <- finalAnswer[variable] + best_delta_i

			output <- paste(output,"                   Final answer: ",paste(finalAnswer,collapse=" "),"\n")
			
			output <- paste(output," (3) Look at importance of surrogate splits","\n")
			ncompete <- frame[node,]$ncompete
			nsurrogate <- frame[node,]$nsurrogate
			if (nsurrogate>0) {
				start <- index[nodeID]
				for (i in seq(start+ncompete+1,start+ncompete+nsurrogate)) {
					variable <- dimnames(splits)[[1]][i]
					value <- splits[i,4]
					best_delta_i <- delta_i(data,variable,value)
					output <- paste(output,"   The best delta_i is:",format(best_delta_i,digits=3),"for",variable,"and",value,"and agreement of",splits[i,3],"\n")
					finalAnswer[variable] <- finalAnswer[variable] + best_delta_i*splits[i,3]
					output <- paste(output,"                   Final answer: ",paste(finalAnswer[2:length(finalAnswer)],collapse=" "),"\n")
					}
				}
			}
		}
	result <- list(result=finalAnswer[2:length(finalAnswer)],info=output)
	class(result) <- "importance.rpart"
	result
	}
print.importance.rpart <- function(self) {
	print(self$result)
	}
summary.importance.rpart <- function(self) {
	cat(self$info)
	}
