#GOV PUBLIC AVAILABLE APIS
## GOV Available Public APIs : https://www.api.gov.uk/tfl/transport-for-london-unified-api/#transport-for-london-unified-api



#NHS API Cyber Alert project
#API github repo : https://github.com/jaegeral/security-apis

## API info --> https://digital.nhs.uk/restapi/CyberAlert/
#Getting started with NHS API https://digital.nhs.uk/developer/getting-started



##Latest Alerts on NHS Website - API Overview : https://digital.nhs.uk/cyber
##API Catalogues : https://digital.nhs.uk/developer/api-catalogue

function getNHSAlert{
$res = Invoke-WebRequest "https://digital.nhs.uk/restapi/CyberAlert/?_limited=true"
$res = $res.content 
#$json = '"{\"pageSize\":10,\"total\":2609,\"items\":[{\"threatId\":\"CC-4404\",\"publishedDate\":1699009980000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4404/cc-4404\",\"title\":\"Apache ActiveMQ RCE Vulnerability CVE-2023-46604\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eA Critical vulnerability that could allow a remote attacker with network access to a broker to run arbitrary shell commands\u003c/p\u003e\"},{\"threatId\":\"CC-4401\",\"publishedDate\":1698763200000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4401/cc-4401\",\"title\":\"Atlassian Releases Security Updates for Critical Vulnerabilities in Confluence Data Center and Confluence Server\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eThe security update addresses one improper authorisation vulnerability and one broken access control vulnerability in Confluence Data Center and Confluence Server\u003c/p\u003e\"},{\"threatId\":\"CC-4403\",\"publishedDate\":1698941460000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4403/cc-4403\",\"title\":\"Cisco Releases Security Updates for Multiple Products\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eUpdates address one critical severity vulnerability in Cisco Firepower Management Center Software in addition to 21 other vulnerabilities\u003c/p\u003e\"},{\"threatId\":\"CC-4399\",\"publishedDate\":1698410220000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4399/cc-4399\",\"title\":\"F5 Releases Security Update for Critical Vulnerability in BIG-IP\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eSecurity update addresses critical remote code execution (RCE) vulnerability in BIG-IP\u003c/p\u003e\"},{\"threatId\":\"CC-4402\",\"publishedDate\":1698849600000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4402/cc-4402\",\"title\":\"F5 Releases Security Update for Vulnerability in BIG-IP\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eSecurity update addresses an SQL injection vulnerability in BIG-IP\u003c/p\u003e\"},{\"threatId\":\"CC-4368\",\"publishedDate\":1692631380000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4368/cc-4368\",\"title\":\"Multiple Vulnerabilities in Juniper Networks Junos OS\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eCritical out-of-band security updates highlight four vulnerabilities that can be chained to achieve pre-authentication remote code execution\u003c/p\u003e\"},{\"threatId\":\"CC-4400\",\"publishedDate\":1698410160000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4400/cc-4400\",\"title\":\"Critical Vulnerability in NextGen HealthCare Mirth Connect\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eThe Critical vulnerability could allow an unauthenticated attacker to perform remote code execution\u003c/p\u003e\"},{\"threatId\":\"CC-4392\",\"publishedDate\":1698327960000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4392/cc-4392\",\"title\":\"Citrix Releases Critical Security Updates for NetScaler ADC and NetScaler Gateway\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eCitrix has released critical security updates addressing one Critical and one High severity vulnerability in NetScaler ADC and NetScaler Gateway\u003c/p\u003e\"},{\"threatId\":\"CC-4345\",\"publishedDate\":1687444440000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4345/cc-4345\",\"title\":\"Apple Releases Security Updates for Multiple Products\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eThe released security updates include three exploited zero-day vulnerabilities in iOS, iPadOS, Safari, watchOS, and macOS\u0026nbsp;\u003c/p\u003e\"},{\"threatId\":\"CC-4398\",\"publishedDate\":1698323580000,\"basePath\":\"http://digital.nhs.uk/cyber-alerts/2023/cc-4398/cc-4398\",\"title\":\"VMware Releases Security Updates for VMware Aria Operations for Logs and Cloud Foundation\",\"versionedNode\":false,\"summary\":\"\u003cp\u003eSecurity updates address two high vulnerabilities affecting VMware Aria Operations for Logs and Cloud Foundation\u003c/p\u003e\"}],\"totalPages\":261,\"currentPage\":1}"'
$obj = $res | ConvertFrom-Json

$id = $obj.items[0].threatId
return $id

}


function moreInfoLatest($id){
if($id -like $null -or $id -like ""){
$id = getNHSAlert
}
$res = Invoke-WebRequest "https://digital.nhs.uk/restapi/CyberAlert/single?threatid=$id"

$res = moreinfo $id | ConvertFrom-Json
$res

}

moreInfoLatest
