import json
from random import randint  
from cassandra.cluster import Cluster
import pymongo

# Connection to advanceddb keyspace
casscluster = Cluster(['localhost'], port=9042)
casssession = casscluster.connect('advanceddb')
#use the correct database
casssession.execute('USE advanceddb')

#Connection to the Mongo databse running on localhost - forcing a direct connection
url="mongodb://localhost:27017"
client = pymongo.MongoClient(url, directConnection=True)
# Working with advanceddb and the factmarks collection
db = client.advanceddb
coll=db.factmarks


#Prepare the query for cassandra
query = casssession.prepare("select * from factmarks")

#We will create a set of insert statements for mongo in a file called cassjson.mongodb
#We will also insert the data directing into the factmarks collection in the MongoDB
filename = 'cassjson.mongodb'
file = open(filename,'w')
rec = 'use ("advanceddb");\n'
file.write(rec)

#iterate through rows retrieved and create the json equivalent
for i in casssession.execute(query):
    print("Setting up insert for Student_sk: ", i.student_sk, " for course ", i.c_name)
    marks=randint(20,80)
    insertentry = json.dumps({
    "student_sk": i.student_sk,
    "s_name": i.s_name,
    "c_name": i.c_name,
    "d_name": i.d_name,
    "marks": marks

    })
    doc={"student_sk": i.student_sk,"s_name": i.s_name,"c_name": i.c_name,"d_name": i.d_name,"marks": marks}

#insert into the mongo database
    coll.insert_one(doc)
#Write an insert for each row to the file   
    rec = 'db.factmarks.insertOne(' + insertentry + ')\n'
    file.write(rec)
    print('hello')
file.close()
#You now have the data in Mongo AND
#You have a file of insert statements you can execute in mongo


