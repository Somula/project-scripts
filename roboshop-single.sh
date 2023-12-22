#!/bin/bash

AMI_ID="ami-03265a0778a880afb"
SG="sg-0a4b59538c2adbf03"
INSTANCES=$1
DOMAIN_NAME="lingaaws.tech"
zoneid="Z0790319IEVF09XXXVM1"

echo "Installing $INSTANCES: $PrivateIpAddress"
if [ $INSTANCES == "mongodb" ] || [ $INSTANCES == "redis" ] || [ $INSTANCES == "mysql" ]
then
    INSTANCE_TYPE="t3.small"
else
    INSTANCE_TYPE="t2.micro"
fi

PrivateIpAddress=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCES}]" --query Instances[0].PrivateIpAddress --output text)


aws route53 change-resource-record-sets \
--hosted-zone-id $zoneid \
--change-batch '
{
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
    "Action"              : "CREATE"
    ,"ResourceRecordSet"  : {
        "Name"              : "'$INSTANCES'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$PrivateIpAddress'"
        }]
    }
    }]
}
    '




