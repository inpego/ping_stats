# Requirements
The application should have the following endpoints:
1) add an IP address to the statistics calculation (parameter is IP address, select the notation yourself)
2) delete the IP address from the statistics calculation (parameter is IP address, select the notation yourself)
3) report ICMP IP address availability statistics [via ping] (parameters are IP address, start of the time interval, end of the time interval). After receiving the beginning and end of the time interval, it should return a JSON containing the following fields:
      - average RTT (ping response time) for this period
      - minimum RTT for this period
      - maximum RTT for this period
      - median RTT for this period
      - standard deviation of RTT measurements for this period
      - percentage of lost ICMP packets (ping) to the specified address for this period.

If for some part of the time in this period the IP address was outside the calculation of statistics (has not been added or was deleted), this part of the time should not be taken into account.

For example, we added the ip-address 8.8.8.8 at 1 o’clock, turned it off at 2, turned it on at 3 and turned it off at 4. If I will request statistics from 1 to 4 hours, the application needs to combine the intervals 1-2, 3-4 and give these statistics on the combined interval. If the IP address was not in the calculation of statistics all the time or there was so little time that we did not have time to make at least 1 measurement, we need to return an error message.


# Usage
## GET /

#### Get ping stats.

Parameters:

**ip_address**: Server's IP address in dot-decimal notation

**start_interval**: Start of time interval in YYYY-MM-DD HH:MM:SS format
      
**end_interval**: End of time interval in YYYY-MM-DD HH:MM:SS format

## POST /
#### Add server's IP address to stats

Parameters:

**ip_address**: Server's IP address in dot-decimal notation

## DELETE /
#### Remove server's IP address from stats

Parameters:

**ip_address**: Server's IP address in dot-decimal notation

