# Work around the Windows Swift ac2207a7 nightly's SIL debug_value verification
# failure. Both main and PR #1 reproduce it; disabling this pass lets tests pass:
# https://github.com/Hokila/swift-testing/actions/runs/37390978977
# Remove this workaround once the nightly-main container has a newer compiler.
$compilerVersion = (& swift --version 2>&1 | Out-String)
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
Write-Host $compilerVersion

$testArguments = @('test')
if ($compilerVersion -match '\bSwift ac2207a7[0-9a-f]*\b') {
    Write-Host 'Applying the Swift ac2207a7 Windows async debug pass workaround.'
    $testArguments += @('-Xswiftc', '-Xllvm', '-Xswiftc', '-sil-disable-pass=sil-moved-async-var-dbginfo-propagator')
}
$testArguments += $args
& swift @testArguments
exit $LASTEXITCODE
