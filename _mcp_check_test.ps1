$headers = @{
    Authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZDY5ZTkyYy1mMDVmLTQ4M2MtYTYwZi01ZTE0MjliMjllNzciLCJpc3MiOiJuOG4iLCJhdWQiOiJtY3Atc2VydmVyLWFwaSIsImp0aSI6ImRkOGRiZjdjLWRiZWEtNDg3Ny05YmY2LTJlMjE2MmY4Nzk1NSIsImlhdCI6MTc4MTgwNTI2OX0.nlkMvN5XMQePg7OKjHpZCX0TKOCz712tdEuJrAan2bk';
    Accept = 'application/json, text/event-stream'
}
$body = '{"jsonrpc":"2.0","id":52,"method":"tools/call","params":{"name":"get_workflow_details","arguments":{"workflowId":"8zph4MTUsZVGW147"}}}'
try {
    $result = Invoke-RestMethod -Uri 'https://n8n.x3c.ca/mcp-server/http' -Method POST -Headers $headers -ContentType 'application/json' -Body $body
    $wf = $result.result.structuredContent.workflow
    Write-Output "name: $($wf.name)"
    Write-Output "active: $($wf.active)"
    Write-Output "versionId: $($wf.versionId)"
    Write-Output "activeVersionId: $($wf.activeVersionId)"
} catch {
    $err = $_.Exception
    Write-Output "Error: $($err.Message)"
}
