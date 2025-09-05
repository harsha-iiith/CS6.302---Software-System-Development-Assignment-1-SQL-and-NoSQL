# NoSQL Implementation

Getting the data into the database

### in mongo shell

use Assignment_1;

### in terminal

mongoimport \
 --db Assignment_1 \
 --collection temperature_data \
 --file "/media/leo/leostore/leostore/leo-ext/college/ssd/assignments/CS6.302---Software-System-Development-Assignment-1-SQL-and-NoSQL/Q2/resources/temperatures_India_100cities_2025_Jan.jsonl"

Checking the data

use Assignment_1;
db.temperature_data.find().limit(5);

## Assumptions

### Q2a

#### Q2a_3

hottest and coldest cities are taken reference based on the average temperature

### Q2b

#### Q2b_1

hottest and coldest days are taken reference based on the min and max temperature
