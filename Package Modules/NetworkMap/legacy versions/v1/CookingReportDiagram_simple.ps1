#----------------------------------------Global Variables ---------------------------------------
$wd = "C:\Users\paulo.bazzo\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram"
cd $wd
$data = Import-Csv "$wd\data.csv" | Where-Object { $_.deviceDirection -ne "" -and $_.deviceDirection -ne $null }
$temp1 = "$wd\temp1.csv"
$allips = "$wd\ips.txt"
$merged = "$wd\merged.csv"
#------------------------------------ DRAW.IO function variables ---------------------------------------
$targetIcon = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$hostIcon = "https://cdn3.iconfinder.com/data/icons/server-rack/64/search-512.png"
#---------------------------------------------------------
#Generate main .csv file and clean up unused columns
function generateCsv {
    $array = @()

    ForEach ($x in $data) {
        $row = New-Object PSObject

        $logged = $x.Logged
        $dhost = $x.dhost.Replace('["','').Replace('"]','')
        $remarks = $x.remarks.Replace('["','').Replace('"]','')
        $peerHost = $x.peerHost
        $ruleName = $x.ruleName
        $app = $x.app
        $act = $x.act.Replace('["','').Replace('"]','')
        $deviceDirection = $x.deviceDirection
        $connectionLegend = $app + " " + $act + " " + $deviceDirection
        $hostName = $x.hostName
        $src = $x.src.Replace('["','').Replace('"]','')
        $dst = $x.dst.Replace('["','').Replace('"]','')
        
        $row | Add-Member -MemberType NoteProperty -Name "ip" -Value $dhost
        $row | Add-Member -MemberType NoteProperty -Name "Logged" -Value $logged
        $row | Add-Member -MemberType NoteProperty -Name "src" -Value $src
        $row | Add-Member -MemberType NoteProperty -Name "dhost" -Value $dhost
        $row | Add-Member -MemberType NoteProperty -Name "remarks" -Value $remarks
        $row | Add-Member -MemberType NoteProperty -Name "peerHost" -Value $peerHost
        $row | Add-Member -MemberType NoteProperty -Name "ruleName" -Value $ruleName
        $row | Add-Member -MemberType NoteProperty -Name "app" -Value $app
        $row | Add-Member -MemberType NoteProperty -Name "deviceDirection" -Value $connectionLegend
        $row | Add-Member -MemberType NoteProperty -Name "hostName" -Value $hostName
        $row | Add-Member -MemberType NoteProperty -Name "image" -Value $targetIcon
        $row | Add-Member -MemberType NoteProperty -Name "fill" -Value "default"
        $row | Add-Member -MemberType NoteProperty -Name "stroke" -Value "#82b366"
        $row | Add-Member -MemberType NoteProperty -Name "ref" -Value ""
        $row | Add-Member -MemberType NoteProperty -Name "link" -Value ""
        # Add this row to the array
        $array += $row
    }

    # Export the array to a CSV file
    $array | Export-Csv $temp1  -NoTypeInformation
}
#Generate Source IP files necessary so each has their own card
function generateAllIps {
    $sourceIps = $data.src.Replace('["','').Replace('"]','') | Sort-Object -Unique
    $ips = $sourceIps
    $ips > $allips

}
#Merge .csv files + ips.txt together
function mergefiles {

$omg = Import-Csv $temp1
$ip = Get-Content $allips

# Create a new object for each IP address and add it to the $omg array
foreach ($record in $ip) {
    $newRow = New-Object PSObject -Property @{
        ip = $record
        image = $hostIcon
        fill = "#B5E7FC"
        stroke = "#3322b3"
    }
    $omg += $newRow
}

# Export the modified data to the $merged CSV file
$omg | Export-Csv $merged -NoTypeInformation
}
#Generate Draw.io script
function generateScript {
$drawio= @"
##
## Example CSV import. Use ## for comments and # for configuration. Paste CSV below.
## The following names are reserved and should not be used (or ignored):
## id, tooltip, placeholder(s), link and label (see below)
##
#
## Node label with placeholders and HTML.
## Default is '%name_of_first_column%'.
#
# label: ip:%ip%<br>hostName:%hostName%<br><i style="color:gray;">DNS:%peerHost%</i><br><i style="color:#228B22;fontSize:15;">Destination:%hostName%</i>
##label: ip:%ip%<br>
# Node style (placeholders are replaced once).
## Default is the current style for nodes.
#
# style: label;image=%image%;whiteSpace=wrap;html=1;rounded=1;fillColor=%fill%;strokeColor=%stroke%;
#
## Parent style for nodes with child nodes (placeholders are replaced once).
#
# parentstyle: swimlane;whiteSpace=wrap;html=1;childLayout=stackLayout;horizontal=1;horizontalStack=0;resizeParent=1;resizeLast=0;collapsible=1;
#
## Style to be used for objects not in the CSV. If this is - then such objects are ignored,
## else they are created using this as their style, eg. whiteSpace=wrap;html=1;
#
# unknownStyle: -
#
## Optional column name that contains a reference to a named style in styles.
## Default is the current style for nodes.
#
# stylename: -
#
## JSON for named styles of the form {"name": "style", "name": "style"} where style is a cell style with
## placeholders that are replaced once.
#
# styles: -
#
## JSON for variables in styles of the form {"name": "value", "name": "value"} where name is a string
## that will replace a placeholder in a style.
#
# vars: -
#
## Optional column name that contains a reference to a named label in labels.
## Default is the current label.
#
# labelname: -
#
## JSON for named labels of the form {"name": "label", "name": "label"} where label is a cell label with
## placeholders.
#
# labels: -
#
## Uses the given column name as the identity for cells (updates existing cells).
## Default is no identity (empty value or -).
#
# identity: -
#
## Uses the given column name as the parent reference for cells. Default is no parent (empty or -).
## The identity above is used for resolving the reference so it must be specified.
#
# parent: -
#
## Adds a prefix to the identity of cells to make sure they do not collide with existing cells (whose
## IDs are numbers from 0..n, sometimes with a GUID prefix in the context of realtime collaboration).
## Default is csvimport-.
#
# namespace: csvimport-
#
## Connections between rows ("from": source colum, "to": target column).
## Label, style and invert are optional. Defaults are '', current style and false.
## If placeholders are used in the style, they are replaced with data from the source.
## An optional placeholders can be set to target to use data from the target instead.
## In addition to label, an optional fromlabel and tolabel can be used to name the column
## that contains the text for the label in the edges source or target (invert ignored).
## In addition to those, an optional source and targetlabel can be used to specify a label
## that contains placeholders referencing the respective columns in the source or target row.
## The label is created in the form fromlabel + sourcelabel + label + tolabel + targetlabel.
## Additional labels can be added by using an optional labels array with entries of the
## form {"label": string, "x": number, "y": number, "dx": number, "dy": number} where
## x is from -1 to 1 along the edge, y is orthogonal, and dx/dy are offsets in pixels.
## An optional placeholders with the string value "source" or "target" can be specified
## to replace placeholders in the additional label with data from the source or target.
## The target column may contain a comma-separated list of values.
## Multiple connect entries are allowed.
#
# connect: {"from": "src", "to": "ip", "invert": true, "sourcelabel": "%deviceDirection% ",\
#          "style": "curved=1;endArrow=blockThick;endFill=1;fontSize=13;"}
## Node x-coordinate. Possible value is a column name. Default is empty. Layouts will
## override this value.
#
# left: 
#
## Node y-coordinate. Possible value is a column name. Default is empty. Layouts will
## override this value.
#
# top: 
#
## Node width. Possible value is a number (in px), auto or an @ sign followed by a column
## name that contains the value for the width. Default is auto.
#
# width: auto
#
## Node height. Possible value is a number (in px), auto or an @ sign followed by a column
## name that contains the value for the height. Default is auto.
#
# height: auto
#
## Collapsed state for vertices. Possible values are true or false. Default is false.
#
# collapsed: false
#
## Padding for autosize. Default is 0.
#
# padding: -12
#
## Comma-separated list of ignored columns for metadata. (These can be
## used for connections and styles but will not be added as metadata.)
#
# ignore: id,image,fill,stroke,refs,manager
#
## Column to be renamed to link attribute (used as link).
#
## link: url
#
## Spacing between nodes. Default is 40.
#
# nodespacing: 60
#
## Spacing between levels of hierarchical layouts. Default is 100.
#
# levelspacing: 50
#
## Spacing between parallel edges. Default is 40. Use 0 to disable.
#
# edgespacing: 2402
#
## Name or JSON of layout. Possible values are auto, none, verticaltree, horizontaltree,
## verticalflow, horizontalflow, organic, circle, orgchart or a JSON string as used in
## Layout, Apply. Default is auto.
#
# layout: auto
#
"@
$data = Get-Content $merged

$drawio > "DrawIo Script.txt"; $data >> "DrawIo Script.txt"


}
#clean up temporary files on system
function cleanup {
Write-Host "[STARTED] Clean up temp files.."-ForegroundColor Cyan 
Remove-Item $allips
Remove-Item $temp1
Remove-Item $merged
}

#run all the functions
function main {
Write-Host "----SCRIPT STARTED----" -ForegroundColor Yellow 
generateCsv
Write-Host "[SUCCESS] Creating temp.csv" -ForegroundColor Green 
generateAllIps
mergefiles
generateScript
Write-Host "[SUCCESS] Draw.io script file generate" -ForegroundColor Green
cleanup
Write-Host "[SUCCESS] Temporary files cleaned up" -ForegroundColor Green
Write-Host "----SCRIPT COMPLETED----" -ForegroundColor Yellow
}
cls
main