from pprint import pprint
import boto3


def run():
    ec2 = boto3.client('ec2')

    instances = ec2.describe_instances()

#pprint(instances)

    spot_requests = ec2.describe_spot_instance_requests(
        Filters=[
            {
                'Name': 'tag:Autorun_MCServer',
                'Values': [
                    'yes',
                ]
            },
            {
                'Name': 'state',
                'Values': [
                    'active',
                ]
            },
        ]
    )

    spot_num = len(spot_requests['SpotInstanceRequests'])

#pprint(spot_requests)
#print(str(spot_num))

    if spot_num != 0:
        print("Error: instance is already running.")
        exit(1)

    res = ec2.request_spot_instances(
#    DryRun = True,
        SpotPrice = '0.12',
        InstanceCount = 1,
        Type = "one-time",
        LaunchSpecification = 
        {
            "ImageId": "ami-7a659e1c",
            "KeyName": "Key",
            "InstanceType": "m4.large",
            "Placement": {
                "AvailabilityZone": "ap-northeast-1a"
            },
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/xvda",
                    "Ebs": {
                        "VolumeSize": 8,
                        "DeleteOnTermination": True,
                        "VolumeType": "standard"
                    }
                }
            ],
            "NetworkInterfaces": [
                {
                    "NetworkInterfaceId": "eni-fa48a5c7",
                    "DeviceIndex": 0
                }
            ],
            "IamInstanceProfile": {
                "Arn": "rn:aws:iam::057833159847:instance-profile/MCServer"
            }
        }
    )
    pprint(res)
    request_id = res['SpotInstanceRequests'][0]['SpotInstanceRequestId']
    res = ec2.create_tags(
        Resources=[request_id],
        Tags=[
            { 'Key': 'Autorun_MCServer', 'Value': 'yes' }
        ]
    )
    pprint(res)

def lambda_handler(event ,context):
    run()

if __name__ == "__main__":
    run()
