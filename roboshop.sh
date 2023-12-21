#!/bin/bash

AMI_ID="ami-03265a0778a880afb"
SG="sg-0a4b59538c2adbf03"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
DOMAIN_NAME="lingaaws.tech"
zoneid="Z0790319IEVF09XXXVM1"
for i in ${INSTANCES[@]}
do
    echo "Instanlling $i"
    if [ $i == "mongodb" ] || [ $i == "redis" ] || [ $i == "mysql" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    PrivateIpAddress=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG --tag-specifications 'ResourceType=instance,Tags=[{Key=name,Value=$i}]' --query Instances[0].PrivateIpAddress --output text)
    
    echo "$i PublicIpAddress is : $PrivateIpAddress"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $zoneid \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$PrivateIpAddress'"
            }]
        }
        }]
    }
        '
done



