### in mongo shell

use assignment_01;

### in terminal

mongoimport \
  --db assignment_01 \
  --collection temperature_data \
  --file "/media/leo/leostore/leostore/leo-ext/college/ssd/assignments/CS6.302---Software-System-Development-Assignment-1-SQL-and-NoSQL/Q2/resources/temperatures_India_100cities_2025_Jan.jsonl"

## in mongo shell

use assignment_01;
db.temperature_data.find().limit(5);