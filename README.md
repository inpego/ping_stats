# Prerequisits
1. RVM
2. PostgreSQL
3. Created database
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