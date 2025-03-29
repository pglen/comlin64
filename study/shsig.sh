 #!/bin/bash

 trap  "echo Signal 15" 15
 trap  "echo Signal " 2
 trap  "echo End script" 0
 trap -p

 echo Hello
 read

# EOF
