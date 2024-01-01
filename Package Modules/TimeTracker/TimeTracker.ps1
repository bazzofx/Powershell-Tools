#by Baroon-Greenback on reddit
#https://old.reddit.com/r/PowerShell/comments/17lnjn4/timekeeping_assistant/
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

#Curent user
$user = $env:USERNAME
######################## CHANGE ME TO THE LOCATION WHERE FILE IS SAVED  - MAKE SURE A BLANK FILE EXIST######
#Location where you would like to save the TimeTracker file
$timeTracker = "C:\Users\$user\OneDrive - NEC Software Solutions\Desktop\TimeTracker.txt"


# Messy way to calculate date and put into the correct format
$currentDateTime = Get-Date
$date                               = get-date -Format MM-dd
$dayOfTheWeek                       =  $currentDateTime.DayOfWeek
$time                               = get-date -Format HH:00



# Create a new form
$CompanionWindow                    = New-Object system.Windows.Forms.Form
$CompanionWindow.startposition      = 'centerscreen'
$CompanionWindow.TopMost            = $true

# Define the size, title and background
$CompanionWindow.ClientSize         = '500,100'
$CompanionWindow.MaximumSize        = $CompanionWindow.Size
$CompanionWindow.MinimumSize        = $CompanionWindow.Size
$CompanionWindow.text               = "Hour Tracker:  $time"
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
    'PAM'
    'Documentation'
    'ISM'
    'Lunch'
    'XDR'
    'Project'
    'Meetings'
    'Resolving tickets'
    'Troubleshotting'
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



        $subject         = $Categories.SelectedItem
        $Categories      = $Categories.SelectedItem
        $content         = $textBox.Text
        $dateTime      =   $ime 

    

$magicString = "$dateTime $dayOfTheWeek`n $subject - $categories - $content"
#Add content to file
Add-Content $timeTracker $magicString



    [void]$CompanionWindow.Close()
}) 
$CompanionWindow.Controls.Add($Button)

# Display the form
$CompanionWindow.AcceptButton = $button
[void]$CompanionWindow.ShowDialog()