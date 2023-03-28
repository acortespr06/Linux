function Get-TimePassed {
    param(
        [string]$startDate
    )

    $today = Get-Date
    $start = [datetime]::ParseExact($startDate, "MM-dd-yyyy", $null)
    $timeSpan = New-TimeSpan $start $today
    $years = [math]::Floor($timeSpan.TotalDays / 365.25)
    $months = [math]::Floor(($timeSpan.TotalDays % 365.25) / 30)

    "Years: $years Months: $months"
}

$date = Read-Host "Enter MM-DD-YYYY: "

Get-TimePassed -startDate $date
