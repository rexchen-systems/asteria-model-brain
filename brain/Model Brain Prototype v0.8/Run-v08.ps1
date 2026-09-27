param([string]$Core='qwen3.5:4b',[string]$EmbeddingModel='bge-m3')
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$worker=Join-Path $root 'Run-Hierarchical.ps1'
. $worker -Mode Library -Core $Core -EmbeddingModel $EmbeddingModel

function Section([string]$text,[string]$name,[string]$next){
 if($next){[regex]::Match($text,"(?ms)^\[$name\](.*?)(?=^\[$next\])").Groups[1].Value}
 else{[regex]::Match($text,"(?ms)^\[$name\](.*)$").Groups[1].Value}
}
function Values([string]$text,[string]$name){@([regex]::Matches($text,'(?m)^'+[regex]::Escape($name)+'=(\d+)\s*$')|ForEach-Object{[int64]$_.Groups[1].Value})}

$v7=Join-Path $root 'baseline\v0.7'
$v7Report=Join-Path $v7 'Test Report v0.7.txt'
$v7Result=Join-Path $v7 'results\latest-result.txt'
if(-not(Test-Path -LiteralPath $v7Report) -or -not(Test-Path -LiteralPath $v7Result)){throw 'v0.7 baseline evidence unavailable'}
$v7ReportHashBefore=(Get-FileHash -LiteralPath $v7Report -Algorithm SHA256).Hash
$v7ResultHashBefore=(Get-FileHash -LiteralPath $v7Result -Algorithm SHA256).Hash
$null=New-Item -ItemType Directory -Force -Path (Join-Path $root 'runs'),(Join-Path $root 'results')

$summary=[Collections.Generic.List[string]]::new();$summary.Add('Asteria Model Brain Prototype v0.8 Result')
$pass=$true;$maxWorking=0L;$maxCandidate=0L;$maxRegionCandidate=0L;$brainBytes=0L;$totalInput=0L;$totalOutput=0L;$totalModelCalls=0L;$totalEmbeddingCalls=0L;$totalLatency=0L;$globalCatalogTouched=$false
foreach($seed in @(808,1808,9808)){
 $run=Join-Path $root "runs\seed-$seed"
 if(Test-Path -LiteralPath $run){Remove-Item -LiteralPath $run -Recurse -Force}
 Build-Brain $run $seed
 $child=Run-Child $run $seed
 if($child.ExitCode-ne0){$summary.Add("SEED_$seed=FAIL_PROCESS");$pass=$false;break}
 $oracle=ReadText (Join-Path $run 'oracle\Expected.txt');$result=ReadText (Join-Path $run 'evidence\Retrieval Result.txt')
 $continuity=Section $result 'continuity' 'speaker';$speaker=Section $result 'speaker' 'incomplete';$incomplete=Section $result 'incomplete' 'unknown';$unknown=Section $result 'unknown' ''
 $ids=Field $continuity 'LOADED_IDS'
 $truth=(Field $continuity 'DECISION')-eq'GO' -and $ids.Contains((Field $oracle 'PERSON_ID')) -and $ids.Contains((Field $oracle 'RELATIONSHIP_ID')) -and $ids.Contains((Field $oracle 'HISTORICAL_ID')) -and $ids.Contains((Field $oracle 'ACTUAL_ID')) -and $ids.Contains((Field $oracle 'CURRENT_ID')) -and $ids.Contains((Field $oracle 'LEARNING_ID'))
 $speakerOk=(Field $speaker 'DECISION')-eq'GO' -and (Field $speaker 'LOADED_IDS')-eq(Field $oracle 'SPEAKER_EVENT_ID')
 $incompleteOk=(Field $incomplete 'DECISION')-eq'HOLD'
 $unknownOk=(Field $unknown 'DECISION')-eq'ASK' -and [int](Field $unknown 'LOADED_NODES')-eq0
 $catalogOk=($result-notmatch'Full Node Catalog') -and ([regex]::Matches($result,'GLOBAL_CATALOG_LOADED=False').Count-eq4)
 if(-not$catalogOk){$globalCatalogTouched=$true}
 $candidateValues=Values $result 'CANDIDATE_COUNT';$regionValues=Values $result 'REGION_CANDIDATE_COUNT';$workingValues=Values $result 'WORKING_SET_BYTES'
 $seedMaxCandidate=($candidateValues|Measure-Object -Maximum).Maximum;$seedMaxRegion=($regionValues|Measure-Object -Maximum).Maximum;$seedMaxWorking=($workingValues|Measure-Object -Maximum).Maximum
 if($seedMaxCandidate-gt$maxCandidate){$maxCandidate=$seedMaxCandidate};if($seedMaxRegion-gt$maxRegionCandidate){$maxRegionCandidate=$seedMaxRegion};if($seedMaxWorking-gt$maxWorking){$maxWorking=$seedMaxWorking}
 $brainBytes=[int64](Field $result 'BRAIN_BYTES');$totalInput+=(Values $result 'INPUT_TOKENS'|Measure-Object -Sum).Sum;$totalOutput+=(Values $result 'OUTPUT_TOKENS'|Measure-Object -Sum).Sum;$totalModelCalls+=(Values $result 'MODEL_CALLS'|Measure-Object -Sum).Sum;$totalEmbeddingCalls+=(Values $result 'EMBEDDING_CALLS'|Measure-Object -Sum).Sum;$totalLatency+=(Values $result 'LATENCY_MS'|Measure-Object -Sum).Sum
 $seedPass=$truth-and$speakerOk-and$incompleteOk-and$unknownOk-and$catalogOk-and$seedMaxCandidate-le16
 $summary.Add("SEED_$seed=$(if($seedPass){'PASS'}else{'FAIL'})")
 if(-not$seedPass){$pass=$false;break}
}
$v7ReportHashAfter=(Get-FileHash -LiteralPath $v7Report -Algorithm SHA256).Hash;$v7ResultHashAfter=(Get-FileHash -LiteralPath $v7Result -Algorithm SHA256).Hash
$baselineUnchanged=$v7ReportHashBefore-eq$v7ReportHashAfter -and $v7ResultHashBefore-eq$v7ResultHashAfter
$bounded=$brainBytes-gt0 -and $maxWorking-lt($brainBytes*0.25) -and $maxCandidate-le16 -and -not$globalCatalogTouched
$all=$pass-and$bounded-and$baselineUnchanged
$summary.Add("GATE_1_SEMANTIC_RELATIONAL=$(if($pass){'PASS_ONCE'}else{'PARTIAL'})")
$summary.Add("GATE_2_MULTI_EVENT=$(if($pass){'PASS_ONCE'}else{'PARTIAL'})")
$summary.Add("GLOBAL_CATALOG_RUNTIME_ACCESS=$(if($globalCatalogTouched){'DETECTED'}else{'NOT_DETECTED'})")
$summary.Add("WORKING_SET_BOUND=$(if($bounded){'PASS_ONCE'}else{'HOLD'})")
$summary.Add("BRAIN_BYTES=$brainBytes");$summary.Add("MAX_WORKING_SET_BYTES=$maxWorking");$summary.Add("MAX_CANDIDATE_COUNT=$maxCandidate");$summary.Add("MAX_REGION_CANDIDATE_COUNT=$maxRegionCandidate");$summary.Add("MODEL_INPUT_TOKENS=$totalInput");$summary.Add("MODEL_OUTPUT_TOKENS=$totalOutput");$summary.Add("MODEL_CALLS=$totalModelCalls");$summary.Add("EMBEDDING_CALLS=$totalEmbeddingCalls");$summary.Add("TOTAL_LATENCY_MS=$totalLatency")
$summary.Add("V07_REPORT_HASH_BEFORE=$v7ReportHashBefore");$summary.Add("V07_REPORT_HASH_AFTER=$v7ReportHashAfter");$summary.Add("V07_RESULT_HASH_BEFORE=$v7ResultHashBefore");$summary.Add("V07_RESULT_HASH_AFTER=$v7ResultHashAfter");$summary.Add("V07_BASELINE_UNCHANGED=$baselineUnchanged")
$summary.Add("GATE=$(if($all){'PASS_ONCE'}else{'PARTIAL'})")
WriteText (Join-Path $root 'results\latest-result.txt') $summary
$summary
if(-not$all){exit 2}
