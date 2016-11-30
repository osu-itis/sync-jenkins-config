#!/bin/bash

TARGET_HOST=changeme

# put jenkins into quiet mode
/opt/scripts/jenkins-job/bin/jenkins-job quiet

# clear jobs dir
ssh root@$TARGET_HOST "rm -rf /var/lib/jenkins/jobs"

# sync config
rsync -avz --exclude-from 'rsync_exclude.txt' /var/lib/jenkins root@$TARGET_HOST:/var/lib/

# reload Jenkins configuration
/opt/scripts/jenkins-job/bin/jenkins-job reload
sleep 30

# disable jobs that shouldn't be running in stage
/opt/scripts/jenkins-job/bin/jenkins-job disable run_vmware-rbscripts_checklogin run_vmware-rbscripts_findTemplateLockingVMs run_vmware-rbscripts_oldsnapshots run_vmware-rbscripts_vmreport run_networker_failure_notifications deploy_dashboard-master

# put jenkins into quiet mode
/opt/scripts/jenkins-job/bin/jenkins-job quiet
