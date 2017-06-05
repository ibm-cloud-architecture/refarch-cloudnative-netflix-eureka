#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/.bluemixrc

#################################################################################
# Remove Eureka container group
#################################################################################
echo "Removing Eureka container group"
cf ic group rm eureka_cluster 