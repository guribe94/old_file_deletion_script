[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
   [string]$path,
  
  [Parameter(Mandatory=$True)]
   [string]$logOutput,
    
	
   [Parameter(Mandatory=$True)]
   [int]$daysBackToDelete
)
 

#Create a date object for when to delete files 
$whenToDelete = (Get-Date).AddDays(-$daysBackToDelete)

#Get all the files in the given path
$files = Get-ChildItem $path -recurse

#Create a log file and put a header at the top 
New-Item $logOutput\FileDeletionScriptLog.txt -type file -force
Add-Content $logOutput\FileDeletionScriptLog.txt "Files deleted by script`n"
Add-Content $logOutput\FileDeletionScriptLog.txt "Name"

#Loop through each file that was found
foreach($file in $files)
    {
        $dayDelta = ((Get-Date) - $file.CreationTime).Day
        if ($dayDelta -gt $whenToDelete.Day -and $file.PsISContainer -ne $True)
            {
            Add-Content ($logOutput + "\FileDeletionScriptLog.txt") "$file`n"
            #Remove-Item $file
            $file.Delete()
            }
    }