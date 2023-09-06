import json
from random import randint  
from cassandra.cluster import Cluster
import pymongo

# Connection to c19366191 keyspace
casscluster = Cluster(['localhost'], port=9042)
casssession = casscluster.connect('c19366191')
#use the correct database
casssession.execute('USE c19366191')

#Connection to the Mongo databse running on localhost - forcing a direct connection
url="mongodb://localhost:27017"
client = pymongo.MongoClient(url, directConnection=True)
# Working with c19366191 and the factmarks collection
db = client.c19366191
coll=db.factresults


#Prepare the query for cassandra
query = casssession.prepare("select * from factresults")

#We will create a set of insert statements for mongo in a file called cassjson.mongodb
#We will also insert the data directing into the factmarks collection in the MongoDB
filename = 'c19366191.mongodb'
file = open(filename,'w')
rec = 'use ("c19366191");\n'
file.write(rec)

#iterate through rows retrieved and create the json equivalent
for i in casssession.execute(query):
    print("Setting up insert for player_sk: ", i.player_sk, " for tournament ", i.t_name)
    insertentry = json.dumps({
    "player_sk": i.player_sk,
    "p_name": i.p_name,
    "t_name": i.t_name,
    "prize": i.prize,
    "rank": i.rank,
    "year": i.year

    })
    doc={"player_sk": i.player_sk,"p_name": i.p_name,"t_name": i.t_name, "prize": i.prize, "rank": i.rank,"year": i.year}

#insert into the mongo database
    coll.insert_one(doc)
#Write an insert for each row to the file   
    rec = 'db.factresults.insertOne(' + insertentry + ')\n'
    file.write(rec)
file.close()
#You now have the data in Mongo AND
#You have a file of insert statements you can execute in mongo


