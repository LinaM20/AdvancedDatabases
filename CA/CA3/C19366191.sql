--MongoDB assignment

--Q3 part a
--Query that involves a text field
--This query finds the tournament name that is Irish Open and display the details
db.factresults.find({t_name : "Irish Open"})
--Explain output of this basic query
db.factresults.find({t_name : "Irish Open"}).explain("executionStats")

--Q3 part b
--Creating a secondary index on a text field
db.factresults.createIndex({p_name:1})
--Showing that the index works
db.factresults.find({p_name : "Ross"})
--Explain output on this secondary index
db.factresults.find({p_name : "Ross"}).explain("executionStats")

--Q4 part a
--Writing a simple aggregation pipeline
--This will get the average prize for Irish open tournaments
db.factresults.aggregate([{ $match:{t_name: "Irish Open"}}, 
{$group: {_id: "$p_name", AvgPrize: {$avg: : "$prize" }}}, 
{$sort: {AvgPrize: -1}}])  
--Explain output on this aggregation pipeline
db.factresults.aggregate([{ $match:{t_name: "Irish Open"}}, 
{$group: {_id: "$p_name", AvgPrize: {$avg: : "$prize" }}}, 
{$sort: {AvgPrize: -1}}]).explain("executionStats")

--Q4 part b
--Creating an index to improve the aggregation performance
db.factresults.createIndex({prize:1})
--Get all the indexes
db.factresults.getIndexes()
--Getting the explain output of the aggregation pipeline
db.factresults.aggregate([{ $match:{t_name: "Irish Open"}}, 
{$group: {_id: "$p_name", AvgPrize: {$avg: : "$prize" }}}, 
{$sort: {AvgPrize: -1}}]).explain("executionStats")