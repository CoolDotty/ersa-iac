$headers = @{
    Authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZDY5ZTkyYy1mMDVmLTQ4M2MtYTYwZi01ZTE0MjliMjllNzciLCJpc3MiOiJuOG4iLCJhdWQiOiJtY3Atc2VydmVyLWFwaSIsImp0aSI6ImRkOGRiZjdjLWRiZWEtNDg3Ny05YmY2LTJlMjE2MmY4Nzk1NSIsImlhdCI6MTc4MTgwNTI2OX0.nlkMvN5XMQePg7OKjHpZCX0TKOCz712tdEuJrAan2bk';
    Accept = 'application/json, text/event-stream'
}

$jsCode = "const files = `$json.body.files`;`nconst repo = `$json.body.repo || `'CoolDotty/n8n-workflows`';`nconst branch = `$json.body.branch || `'main`';`nreturn files.map(function(file) {`n  var idMatch = file.match(/workflows`\`/([^-]+)/);`n  return {`n    fileName: file,`n    repo: repo,`n    branch: branch,`n    rawUrl: `'https://api.github.com/repos/`' + repo + `'/contents/`' + file + `'?ref=`' + branch`n  };`n});"
$jsCode = $jsCode.Replace("`$", "$").Replace("`'", "'").Replace("`n", "`n").Replace("`\`", "\\")

$body = '{"jsonrpc":"2.0","id":62,"method":"tools/call","params":{"name":"update_workflow","arguments":{"workflowId":"cNyZx8zOIOcEa4WT","operations":[{"type":"setNodeParameter","nodeName":"Parse Changed Files","path":"/jsCode","value":"' + $jsCode.Replace('\', '\\').Replace('"', '\"').Replace("`r`n", "\n").Replace("`n", "\n") + '"},{"type":"setNodeParameter","nodeName":"Parse Changed Files","path":"/mode","value":"runOnceForAllItems"}]}}}'

try {
    $result = Invoke-RestMethod -Uri 'https://n8n.x3c.ca/mcp-server/http' -Method POST -Headers $headers -ContentType 'application/json' -Body $body
    Write-Output ($result | ConvertTo-Json -Depth 10)
} catch {
    Write-Output "Error: $($_.Exception.Message)"
}
