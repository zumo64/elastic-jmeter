#cat file.csv | awk '{print $0 ",request1.json"}' > file.csv
dt = require('datetimejs')

# date intervals
date1 = process.argv[2]
date2 = process.argv[3]

#generate intervals 
interval = process.argv[4]

# unit is s,m,h,d
unit = process.argv[5]

#number samples
nbSamples = process.argv[6]


#date_start = Date.parse(date1)
#date_end = Date.parse(date2)
date_start = dt.strptime(date1,'%d/%m/%Y %H:%M:%S')  
date_end = dt.strptime(date2,'%d/%m/%Y %H:%M:%S') 

# date_start = dt.strptime('10/09/2016 00:00:00','%d/%m/%Y %H:%M:%S')
# date_end = dt.strptime('19/09/2016 23:13:42','%d/%m/%Y %H:%M:%S')

timeSpan = date_end.getTime() / 1000 - date_start.getTime() / 1000

# Hard codod values For testing
# nbSamples=10

# intervalHour = 0.5


factor = null
switch unit
  when "h"
    factor = 3600000
  when "m"
    factor = 600000
  when "d"
    factor = 24 * 60 * 60
  when "s"
    factor = 1000
  else
    console.log "invalid unit should be h,m,d,s"
    
  
if factor?
  for i in [0..nbSamples]
    rd = Math.round(Math.random() * timeSpan)
    startRandomIntervalTime = date_start.getTime() / 1000 + rd
    endRandomIntervalTime = startRandomIntervalTime + interval * factor
    #console.log "#{date_end.getTime() / 1000}  #{date_start.getTime() / 1000}  #{timeSpan}  #{rd}"
    console.log "#{startRandomIntervalTime * 1000},#{endRandomIntervalTime * 1000}"
    




