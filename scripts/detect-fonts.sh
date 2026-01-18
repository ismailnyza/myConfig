#!/usr/bin/env bash

echo "🔤 Checking fonts..."

fc-list | grep -qi "JetBrains Mono" || echo "❌ JetBrains Mono missing"
fc-list | grep -qi "Noto" || echo "❌ Noto fonts missing"

