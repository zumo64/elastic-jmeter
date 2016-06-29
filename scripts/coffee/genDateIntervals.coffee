require('datejs')

# date intervals
date1 = process.argv[2]
date2 = process.argv[3]

#generate intervals 
interval = process.argv[4]

# unit is s,m,h,d
unit = process.argv[5]

#number samples
nbSamples = process.argv[6]


date_start = Date.parse(date1)
date_end = Date.parse(date2)

timeSpan = date_end.getTime() - date_start.getTime()

# Hard codod values For testing
# nbSamples=10
# date_start = Date.parse('22/08/2015 23:13:42','d/M/yyyy HH:mm:ss')
# date_end = Date.parse('23/08/2015 23:13:42','d/M/yyyy HH:mm:ss')
# intervalHour = 0.5

factor = null
switch unit
  when "h"
    factor = 3600000
  when "m"
    factor = 600000
  when "d"
    factor = 24 * 3600000
  when "s"
    factor = 1000
  else
    console.log "invalid unit should be h,m,d,s"
    
  
if factor?
  for i in [0..nbSamples]
    startRandomIntervalTime = date_start.getTime() + Math.round(Math.random() * timeSpan)
    endRandomIntervalTime = startRandomIntervalTime + interval * factor
    console.log "#{startRandomIntervalTime},#{endRandomIntervalTime}"

#console.log "#{new Date(startRandomIntervalTime)},#{new Date(endRandomIntervalTime)}"
#console.log "#{date_start}"
#console.log "#{timeSpan}"
#console.log "#{startRandomIntervalTime},#{endRandomIntervalTime}"





