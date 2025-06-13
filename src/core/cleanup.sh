#!/bin/bash
# ===========================================
# cleanup
# ===========================================
#
# Temp Dateien löschen

cleanup() {
    log_info "Räume temporäre Dateien auf..."
}


trap cleanup EXIT