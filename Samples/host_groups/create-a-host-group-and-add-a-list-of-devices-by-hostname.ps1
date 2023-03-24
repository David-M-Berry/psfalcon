#Requires -Version 5.1
using module @{ModuleName='PSFalcon';ModuleVersion ='2.2'}
param(
    [Parameter(Mandatory,Position=1)]
    [ValidatePattern('\.txt$')]
    [ValidateScript({
        if (Test-Path -Path $_ -PathType Leaf) {
            $true
        } else {
            throw "Cannot find path '$_' because it does not exist or is a directory."
        }
    })]
    [string]$Path,
    [Parameter(Mandatory,Position=2)]
    [string]$Name,
    [Parameter(Position=3)]
    [string]$Description
)
# Create host group
$Param = @{ GroupType = 'static'; Name = $Name }
if ($Description) { $Param['Description'] = $Description }
$Group = New-FalconHostGroup @Param
if (!$Group) { throw "Failed to create host group. Check permissions." }

# Use Find-FalconDuplicate to find hosts and add them to the new group
Find-FalconHostname -Path $Path -OutVariable HostList | Invoke-FalconHostGroupAction -Name add-hosts -Id $Group.id
if (!$HostList) { throw "No hosts found." }