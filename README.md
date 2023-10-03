# Cloud applications

In this repository, we will keep code and procedures to deploy cloud applications that researchers might need.

## Windows GUI applications
In some instances, users need to analyze data in an graphical user interface (GUI) application. For these cases, the folder `win_ec2` contains a cloud formation script to deploy a Windows server 2022 instance, that can be accessed using an RDP client.

## Notes on getting the latest ami  
AMI are usually fixed in the cloud formation templates, and they depend on the region the user is located in. The cloud formation templates used here select the AMI for the user's region, and that AMI es obtained from a map (dictionary) in the teplate file itself. The following commands were used to get Ubuntu and Windows AMIs. At this state, the output needs to be cleaned

### Ubuntu
```bash
for region in $(aws account list-regions --no-cli-pager | jq '.Regions[].RegionName' | tr -d '"')
do 
    image=$(aws ssm get-parameters --names /aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id --region $region --no-cli-pager | jq '.Parameters[] | .Value')
    echo "{\"$region\":$image}"
 done
```

### Windows

```bash
for region in $(aws account list-regions --no-cli-pager | jq '.Regions[].RegionName' | tr -d '"')
do
    image=$(aws ssm get-parameters-by-path --path "/aws/service/ami-windows-latest" --region $region --no-cli-pager | jq '.Parameters[] | select(.Name | contains("/Windows_Server-2022-English-Full-Base")) | .Value')
    echo "{\"$region\":$image}"; done
```
