#!/bin/bash

# Script to test if adblock functionality is working

echo "Testing adblock functionality..."

# Test a known ad domain
TEST_DOMAIN="doubleclick.net"
echo "Testing if $TEST_DOMAIN is blocked..."

# Try to resolve the domain using the local DNS server
RESULT=$(timeout 5 dig @$TEST_DOMAIN +short 2>/dev/null | head -n 1)

if [ "$RESULT" = "0.0.0.0" ] || [ "$RESULT" = "" ]; then
    echo "✓ $TEST_DOMAIN is properly blocked"
else
    echo "✗ $TEST_DOMAIN is not blocked (resolved to: $RESULT)"
fi

# Test a known non-ad domain to ensure normal DNS still works
TEST_DOMAIN2="google.com"
echo ""
echo "Testing if normal DNS resolution still works for $TEST_DOMAIN2..."

RESULT2=$(timeout 5 dig @$TEST_DOMAIN2 +short 2>/dev/null | head -n 1)

if [ "$RESULT2" != "" ] && [ "$RESULT2" != "0.0.0.0" ]; then
    echo "✓ Normal DNS resolution works (resolved to: $RESULT2)"
else
    echo "✗ Normal DNS resolution may be broken"
fi

echo ""
echo "Adblock functionality test completed."