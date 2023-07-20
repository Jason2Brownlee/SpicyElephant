#!/bin/bash
echo "Spicy Notification Emails: $(date)" >> /var/www/apps/spicyelephant_com/current/log/notification.log
GEM_PATH=/usr/local/lib/ruby/gems/1.8
GEM_HOME=/usr/local/lib/ruby/gems/1.8
/usr/local/bin/ruby /var/www/apps/spicyelephant_com/current/script/runner 'User.send_notifications' -e production 2>&1 >> /var/www/apps/spicyelephant_com/current/log/notification.log
