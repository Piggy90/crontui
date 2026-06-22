#!/usr/bin/env bash
# ==============================================================================
#  CRONTUI UNIT TESTS
# ==============================================================================

# Source the main crontui file (it won't run the main loop because of the guard)
source ./crontui

# Test status counter
failed=0
passed=0

assert_equals() {
    local expected="$1"
    local actual="$2"
    local msg="$3"
    
    if [ "$expected" = "$actual" ]; then
        echo -e "\033[0;32m✔ PASS:\033[0m $msg"
        ((passed++))
    else
        echo -e "\033[0;31m✘ FAIL:\033[0m $msg"
        echo "   Expected: '$expected'"
        echo "   Actual:   '$actual'"
        ((failed++))
    fi
}

echo "Running CronTUI Unit Tests..."
echo "============================================================"

# 1. Test dow_to_name
assert_equals "Mon" "$(dow_to_name 1)" "dow_to_name 1 -> Mon"
assert_equals "Sun" "$(dow_to_name 7)" "dow_to_name 7 -> Sun"
assert_equals "Sun" "$(dow_to_name 0)" "dow_to_name 0 -> Sun"
assert_equals "Sat" "$(dow_to_name 6)" "dow_to_name 6 -> Sat"

# 2. Test in_list
in_list 3 "1 2 3 4"
assert_equals "0" "$?" "in_list 3 in '1 2 3 4' -> true (0)"
in_list 5 "1 2 3 4"
assert_equals "1" "$?" "in_list 5 in '1 2 3 4' -> false (1)"

# 3. Test expand_field
assert_equals "0 6 12 18" "$(expand_field "*/6" 23 | xargs)" "expand_field */6 max 23"
assert_equals "1 2 3 4 5" "$(expand_field "1-5" 7 | xargs)" "expand_field 1-5 max 7"
assert_equals "1 3 5" "$(expand_field "1,3,5" 7 | xargs)" "expand_field 1,3,5 max 7"
assert_equals "0 1 2 3" "$(expand_field "*" 3 | xargs)" "expand_field * max 3"

# 4. Test get_job_label
assert_equals "multicloud-sync" "$(get_job_label "/usr/local/bin/cron-notify.sh --success multicloud-sync -- bash -c '...'")" "get_job_label with --success flag"
assert_equals "cron-digest (Lab)" "$(get_job_label "CRON_DIGEST_LABEL=Lab /usr/local/bin/cron-digest.sh")" "get_job_label with CRON_DIGEST_LABEL"
assert_equals "backup.sh" "$(get_job_label "/root/scripts/backup.sh --all")" "get_job_label fallback to basename"

echo "============================================================"
echo -e "Summary: \033[0;32m$passed passed\033[0m, \033[0;31m$failed failed\033[0m"

if [ $failed -eq 0 ]; then
    exit 0
else
    exit 1
fi
