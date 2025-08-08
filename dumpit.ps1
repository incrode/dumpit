
$pname = $args[0]
$pdir = "${pname}"
$tdir = "./templates"

# Usage: Dumps the command usage
function Usage() {
    Write-Host("Usage: dumpit.ps1 <project>");
    exit 0;
}


# GetStartTemplate: choose the template in `$tdir`
function GetStartTemplate() {
    $i = 1;
    $arr = @();
    Write-Host "";

    foreach ($currentItemName in (Get-ChildItem $tdir).Name) {
        Write-Host $i". "$currentItemName;
        $arr = $arr + $currentItemName;
        $i++;
    }

    Write-Host "";
    $template = $arr[(Read-Host "Please select a template number") - 1];
    Write-Host "";

    return $template;
}


if (-not $pname) {
    Usage;
    exit 1;
} 
elseif (-not (Test-Path -Path $tdir -PathType Container)) {
    Write-Output "Please provide valid 'templates' path!";
    exit 2;
}
elseif (Test-Path -Path $pdir -PathType Container) {
    Write-Output "Project directory already exits!";
    exit 3;
}

$template = GetStartTemplate;

if (-not $template) {
    Write-Output "Template not found!";
    exit 4;   
}

Copy-Item -R "$tdir/$template" $pdir
Set-Location $pdir

foreach ($file in (Get-ChildItem -Recurse -Force)) {
    
    # checking for directories and binary files
    #                               |-----> checking if first 4KB are 0 (likely to be binary)
    if (!(Test-Path $file -PathType Container) -and 
        (-not ([System.IO.File]::ReadAllBytes($file.FullName)[0..([Math]::Min(4095, [System.IO.File]::ReadAllBytes($file.FullName).Length - 1))] -contains 0))) 
    {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $newContent = $content -replace 'PROJECTNAME', $pname
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8
    }

    if ($file.Name -like '*PROJECTNAME*') {
        $newName = $file.Name -replace 'PROJECTNAME', $pname

        if ([string]::IsNullOrWhiteSpace($newName) -or $newName -eq $file.Name) {
            continue
        }

        $parent = $file.PSParentPath -replace '^Microsoft\.PowerShell\.Core\\FileSystem::', ''
        if (-not $parent) {
            continue
        }

        $newPath = Join-Path $parent $newName

        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $file.FullName -NewName $newPath -Force
        } 
    }
}
