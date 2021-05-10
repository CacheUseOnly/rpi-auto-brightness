# auto-brightness.sh
## Usage
\# auto-brightness.sh [-v verbose output] [-s starthour] [-e endhout] 
[-d|--dim brightness in night time] [-b|--bright birghtness in day time]

## Description
Dim the backlight in night time, reset in day time. 
Requires sudo priviledge. Recommend running in background(&).
When it is not the time to change brightness, the script will `sleep`.