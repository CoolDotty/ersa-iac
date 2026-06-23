$headers = @{
    Authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZDY5ZTkyYy1mMDVmLTQ4M2MtYTYwZi01ZTE0MjliMjllNzciLCJpc3MiOiJuOG4iLCJhdWQiOiJtY3Atc2VydmVyLWFwaSIsImp0aSI6ImRkOGRiZjdjLWRiZWEtNDg3Ny05YmY2LTJlMjE2MmY4Nzk1NSIsImlhdCI6MTc4MTgwNTI2OX0.nlkMvN5XMQePg7OKjHpZCX0TKOCz712tdEuJrAan2bk';
    Accept = 'application/json, text/event-stream'
}

$body = '{"jsonrpc":"2.0","id":60,"method":"tools/call","params":{"name":"search_executions","arguments":{"workflowId":"cNyZx8zOIOcEa4WT","limit":5}}}'

try {
    $result = Invoke-RestMethod -Uri 'https://n8n.x3c.ca/mcp-server/http' -Method POST -Headers $headers -ContentType 'application/json' -Body $body
    Write-Output ($result | ConvertTo-Json -Depth 10)
} catch {
    Write-Output "Error: $($_.Exception.Message)"
}
