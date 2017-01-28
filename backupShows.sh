#!/bin/bash
RSYNC_PATH="/usr/local/bin/rsync"

echo BEGIN `date` >> ~/Library/Logs/backup.log
~/bin/mountSharecentre.sh >> ~/Library/Logs/backup.log 2>&1

/usr/bin/caffeinate -s $RSYNC_PATH -rLtvhx --exclude='shared' --exclude=‘tmp’ --exclude='.DS_Store' --exclude='.AppleDouble' --exclude='.fcpcache' \
  /Users/walkingdude/shows/ \
  ~/sharecentre/shows/ 2>&1 | tee -a ~/Library/Logs/backup.log

sync
~/bin/umountSharecentre.sh >> ~/Library/Logs/backup.log 2>&1
echo END `date` >> ~/Library/Logs/backup.log

# a = rlptgoD   (NO)
# r - recursive   (Y) 
# l - symlinks as symlinks (NO)
# L - contents of symlinks! (Y)
# p - preserve permissions (NO)
# t - preserve modification times (Y)
# g - preserve group (Y)
# o - preserve owner  (Y)
#u - skip files that are newer in dst (?)
#v - verbose (Y)
#h - human readable (Y)
#H - preserve hard links (Y)
#x - don't cross file system boundries (Y)
#
#-avhHx --chmod=777
