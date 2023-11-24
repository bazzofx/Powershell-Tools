#by Baroon-Greenback on reddit
#https://old.reddit.com/r/PowerShell/comments/17lnjn4/timekeeping_assistant/
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Connect to Graph
Import-Module -name Microsoft.Graph.Beta.Calendar
Connect-MgGraph -ClientID "__" -TenantId "__" -CertificateThumbprint "__" | out-null

# UserID and CalendarID
$user    = "__"
$userid  = (get-mguser -userid "$user").id
$calid   = (get-mgusercalendar -userid "$user" | where-object { $_.Name -eq 'Calendar' }).id

# Messy way to calculate date and put into the correct format
$Date                               = get-date -Format yyyy-MM-dd
$Time                               = get-date -Format HH:00:00
$starthourdiscovery = (get-date -format HH ) - 1
if ( ($starthourdiscovery | Measure-Object -Character).Characters -lt '2' ){ $starthour = "0$starthourdiscovery" }
else { $starthour = "$starthourdiscovery" }
$starttime                          = (get-date -Format $starthour+00:00).Replace("+",":")
$fullstarttime                      = $date + "T" + $starttime
$fullendtime                        = $date + "T" + $Time

# Create a new form
$CompanionWindow                    = New-Object system.Windows.Forms.Form
$CompanionWindow.startposition      = 'centerscreen'
$CompanionWindow.TopMost            = $true

# Define the size, title and background
$CompanionWindow.ClientSize         = '500,100'
$CompanionWindow.MaximumSize        = $CompanionWindow.Size
$CompanionWindow.MinimumSize        = $CompanionWindow.Size
$CompanionWindow.text               = "Calendar Companion:  $starttime - $time"
$CompanionWindow.FormBorderStyle    = "FixedSingle"
$CompanionWindow.BackColor          = "Chocolate"
$Font                               = New-Object System.Drawing.Font("Ariel",13)

# Text Input
$textBox                            = New-Object System.Windows.Forms.TextBox
$textBox.Location                   = New-Object System.Drawing.Point(32,60)
$textBox.Size                       = New-Object System.Drawing.Size(440,30)
$textBox.Height                     = 20
$textBox.BackColor                  = "DarkGray"
$textBox.ForeColor                  = "Black"
$textBox.BorderStyle                = "None"
$textBox.Font                       = $font
$textBox.TabIndex                   = 1
$CompanionWindow.Controls.Add($textBox)

# Sits under textbox to give a small border
$header                             = New-Object System.Windows.Forms.label
$header.Location                    = New-Object System.Drawing.Point(26,57)
$header.Height                      = 29
$header.Width                       = 450
$header.BackColor                   = "DarkGray"
$header.BorderStyle                 = "FixedSingle"
$CompanionWindow.Controls.Add($header)

# Categories Dropdown
# Possible to auto-extract these from Outlook?
$CategoryList = @(
    'BAU'
    'Documentation'
    'Escalation'
    'Lunch'
    'Ordering'
    'Project'
    'Reactionary'
    'Reading'
    'Routine Tasks'
    'Scripting'
    'Training ( Providing )'
    'Training ( Receiving )' 
)

$Categories                         = New-Object system.Windows.Forms.ComboBox
$Categories.location                = New-Object System.Drawing.Point(27,18)
$Categories.Width                   = 340
$Categories.Height                  = 30
$CategoryList | ForEach-Object {[void] $Categories.Items.Add($_)}
$Categories.SelectedIndex           = 0
$Categories.BackColor               = "DarkGray"
$Categories.ForeColor               = "Black"
$Categories.FlatStyle               = "Flat"
$Categories.Font                    = $Font
$Categories.MaxDropDownItems        = 20
$Categories.TabIndex                = 0
$CompanionWindow.Controls.Add($Categories)

#Submit Button
$Button                             = new-object System.Windows.Forms.Button
$Button.Location                    = new-object System.Drawing.Size(375,17)
$Button.Size                        = new-object System.Drawing.Size(100,30)
$Button.Text                        = "Submit"
$Button.BackColor                   = "DarkGray"
$Button.ForeColor                   = "Black"
$Button.FlatStyle                   = "Flat"
$Button.Add_Click({

    $params = @{
        subject         = $Categories.SelectedItem
        Categories      = $Categories.SelectedItem
        body = @{
            contentType = "HTML"
            content     = $textBox.Text
        }
        start = @{
            dateTime    = "$fullstarttime"
            timeZone    = "GMT Standard Time"
        }
        end = @{
            dateTime    = "$fullendtime"
            timeZone    = "GMT Standard Time"
        }
    }

    New-MgBetaUserCalendarEvent -UserId $userid -CalendarId $calid -BodyParameter $params | Out-Null
    [void]$CompanionWindow.Close()
}) 
$CompanionWindow.Controls.Add($Button)

# Display the form
$CompanionWindow.AcceptButton = $button
[void]$CompanionWindow.ShowDialog()
