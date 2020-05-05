
#Comment out this section line for local debug. Handle both old and new urls https://fabrikamfiber.visualstudio.com/ and https://dev.azure.com/fabrikamfiber/ 
$CollectionName = ([System.Uri]$env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI).Host.split('.')[-3]

if ($CollectionName -eq 'dev'){
    $CollectionName = ([System.Uri]$env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI).Host.split('/')[-2]
}
##########

#Will need to set these for local debug
#  $CollectionName = ""
#  $env:SYSTEM_ACCESSTOKEN = ""
#  $env:BUILD_ARTIFACTSTAGINGDIRECTORY=""
#END DEBUG SECTION

try {
  $url = "https://vsaex.dev.azure.com/$CollectionName/_apis/userentitlements?"
  $result = Invoke-RestMethod -Uri $url -ContentType "application/json" -Headers @{ Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
  Write-Host "*******************members*********************************"
  $outputFile = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/users.md"
    
  "|{0}|{1}|{2}|{3}|{4}|{5}|" -f "Name", "Username", "Access Level", "Last Access", "Date Created", "Out of Compliance" | add-content -path $outputFile
  "|---  |---  |---  |---  |---  |:---:|" | add-content -path $outputFile

  foreach ($member in $result.members) {
    #Write-Output $member.user.displayName
    if (($member.lastAccessedDate -lt (Get-Date).AddDays(-30)) -and ($member.accessLevel.licenseDisplayName -ne "Stakeholder")) {
      Write-Output $member.user.displayName $member.accessLevel.licenseDisplayName
      "|{0}|{1}|{2}|{3}|{4}|{5}|" -f $member.user.displayName, $member.user.mailAddress, $member.accessLevel.licenseDisplayName, $member.lastAccessedDate, $member.dateCreated, "X" | add-content -path $outputFile
    }
    else {
      "|{0}|{1}|{2}|{3}|{4}|  |" -f $member.user.displayName, $member.user.mailAddress, $member.accessLevel.licenseDisplayName, $member.lastAccessedDate, $member.dateCreated | add-content -path $outputFile
    }
  }
}
catch {
  Write-Error $_
  Write-Error $_.Exception.Message
}