
sudo docker compose --env-file .env.docker build
export KEPLOY_API_KEY=eBzu6AWJvsmbQ2IvUg==

curl --silent -o keployE --location https://keploy-enterprise.s3.us-west-2.amazonaws.com/releases/0.7.6/enterprise_linux_amd64
sudo chmod a+x keployE && sudo mkdir -p /usr/local/bin && sudo mv keployE /usr/local/bin

# Build the project locally
echo "Project built successfully"


sudo -E env PATH="$PATH" /usr/local/bin/keployE test -c "sudo docker compose --env-file .env.docker up" --containerName "fast-api-app" --delay 30 --apiTimeout 300 --generateGithubActions=false
echo "Keploy started in test mode"

all_passed=true

# Loop through test sets
for i in {0..0}
do
    # Define the report file for each test set
    report_file="./keploy/reports/test-run-0/test-set-$i-report.yaml"

    # Extract the test status
    test_status=$(grep 'status:' "$report_file" | head -n 1 | awk '{print $2}')

    # Print the status for debugging
    echo "Test status for test-set-$i: $test_status"

    # Check if any test set did not pass
    if [ "$test_status" != "PASSED" ]; then
        all_passed=false
        echo "Test-set-$i did not pass."
        break # Exit the loop early as all tests need to pass
    fi
done

# Check the overall test status and exit accordingly
if [ "$all_passed" = true ]; then
    python3 -m coverage combine
    python3 -m coverage report
    echo "All tests passed"
    exit 0
else
    exit 1
fi
