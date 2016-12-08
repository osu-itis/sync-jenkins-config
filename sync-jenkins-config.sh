#!/bin/bash

if [ -z "$SYNC_JENKINS_HOST" ]; then
  echo "The SYNC_JENKINS_HOST environment variable must be set."
  exit 1
fi

# put jenkins into quiet mode
/opt/scripts/jenkins-job/bin/jenkins-job quiet

# backup nodes dir
ssh root@$SYNC_JENKINS_HOST "cp -r /var/lib/jenkins/nodes /tmp/"

# clear jobs dir
ssh root@$SYNC_JENKINS_HOST "rm -rf /var/lib/jenkins/jobs"

# sync config
rsync -avz --exclude-from 'rsync_exclude.txt' /var/lib/jenkins root@$SYNC_JENKINS_HOST:/var/lib/

# restore nodes dir
ssh root@$SYNC_JENKINS_HOST "cp -r /tmp/nodes /var/lib/jenkins/jobs/"

# reload Jenkins configuration
/opt/scripts/jenkins-job/bin/jenkins-job reload
sleep 30

# disable jobs that shouldn't be running in stage
/opt/scripts/jenkins-job/bin/jenkins-job disable run_vmware-rbscripts_checklogin run_vmware-rbscripts_findTemplateLockingVMs run_vmware-rbscripts_oldsnapshots run_vmware-rbscripts_vmreport run_networker_failure_notifications deploy_dashboard-master

# put jenkins into quiet mode
/opt/scripts/jenkins-job/bin/jenkins-job quiet
