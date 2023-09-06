import psycopg2
import psycopg2.extras
import json
import collections
import cassandra
from cassandra.cluster import Cluster
import time

# This connects to Postgres using the configuration settings 
conn_string = "host='localhost' port='5432' dbname='postgres' user='linam' password='password'"
pgcon = psycopg2.connect(conn_string)

# Cursor will store the query results and the Query gets the fact table from golf 
# It will get the name of the player, the tournament they are in, the prize they won, the year and rank.
cursor = pgcon.cursor()
cursor.execute("select fr.player_sk, dp.p_sname as p_lastname, dt.t_descriprion as t_desc, fr.prize, rank, year from factresults fr join dimplayer dp on fr.player_sk = dp.player_sk join dimdate dd on fr.date_sk = dd.date_sk join dimtournament dt on fr.tournament_sk = dt.tournament_sk;")
rows = cursor.fetchall()

rowarray_list = []
for row in rows:
    t = (row[0], row[1], row[2], row[3], row[4], row[5])
    rowarray_list.append(t)

# Creates a javascript file of the rows
j = json.dumps(rowarray_list)
with open("pgqueryextractrows.js", "w") as f:
    f.write(j)

# Convert query to objects of key-value pairs into a json files
# Takes the rows, player sk, player name, tournament name, prize, rank and the year.
objects_list = []
for row in rows:
    d = collections.OrderedDict()
    d["player_sk"] = row[0]
    d["p_name"] = row[1]
    d["t_name"] = row[2]
    d["prize"] = row[3]
    d["rank"] = row[4]
    d["year"] = row[5]
    objects_list.append(d)
j = json.dumps(objects_list)
with open("C19366191.json", "w") as f:
    f.write(j)

pgcon.close()

# Connecting to the advanceddb keyspace on port 9042
casscluster = Cluster(['localhost'], port=9042)
casssession = casscluster.connect('advanceddb')
casssession.execute('USE advanceddb')

# This will create a table in Cassandra and drop the table if it exists
casssession.execute('Drop table IF EXISTS factresults;')
casssession.execute('Create table factresults ( player_sk int, p_name text, t_name text, prize float, rank int, year int, primary key (player_sk, p_name));')

# Prepared statement and passing in different values. Execution is sped up this way.
# The prepared statement is inserting into the factresults table the player details, their rank, prize, tournament year and name
query = casssession.prepare("insert into factresults (player_sk,p_name,t_name,prize,rank,year) VALUES (?,?,?,?,?,?)")
print (query)        
text_id=1
with open("C19366191.json") as data_file:
    data = json.load(data_file)

# loops through data rows
    for v in data:
        print('Uploading to Cassandra - row ' + str(text_id)) 
        print (v['p_name'])
        r_player_sk = v['player_sk'] 
        r_p_name = v['p_name']
        r_t_name =  v['t_name'] 
        r_prize = v['prize'] 
        r_rank = v['rank'] 
        r_year = v['year'] 
        text_id += 1
        
# Query to pass the required values 
        casssession.execute(query, [r_player_sk, r_p_name, r_t_name, r_prize, r_rank, r_year])
       
# Waiting to make sure the data is sent
print("Pausing for 1 minute to ensure data submission")
time.sleep(60)
print("Done")
