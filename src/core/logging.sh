#!/bin/bash
# ===========================================
# Logging
# ===========================================



# Hilfsfunktion für farbige Ausgaben
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}




# Banner anzeigen
show_banner() {
    echo -e "${BLUE}"
    echo "=========================================="
    echo "    AUTOMATED PENETRATION TESTING TOOL   "
    echo "=========================================="
    echo -e "${NC}"
}
