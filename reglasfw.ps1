# Obtener todas las reglas de firewall habilitadas
$firewallRules = Get-NetFirewallRule | Where-Object { $_.Enabled -eq "True" }

# Comprobar si hay reglas habilitadas
if ($firewallRules.Count -eq 0) {
    Write-Output "No hay reglas de firewall habilitadas."
} else {
    # Mostrar información detallada de las reglas en formato de tabla
    $firewallRules | Select-Object Name, Direction, Action, DisplayName, Description |
    Format-Table -AutoSize

    # Preguntar al usuario si desea deshabilitar alguna regla
    $disableRule = Read-Host "¿Deseas deshabilitar alguna regla? (Sí/No)"
    if ($disableRule -eq "Sí") {
        $ruleName = Read-Host "Introduce el nombre de la regla que deseas deshabilitar"
        $rule = Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue

        if ($rule) {
            Disable-NetFirewallRule -Name $ruleName
            Write-Output "La regla '$ruleName' ha sido deshabilitada."
        } else {
            Write-Output "No se encontró ninguna regla con el nombre '$ruleName'."
        }
    }

    # Exportar la información a un archivo CSV
    $export = Read-Host "¿Deseas exportar la información a un archivo CSV? (Sí/No)"
    if ($export -eq "Sí") {
        $filePath = Read-Host "Introduce la ruta del archivo CSV (ejemplo: C:\reglas_firewall.csv)"
        $firewallRules | Select-Object Name, Direction, Action, DisplayName, Description |
        Export-Csv -Path $filePath -NoTypeInformation
        Write-Output "La información ha sido exportada a '$filePath'."
    }
}