#!/bin/sh

set -e
USER="wcs"

# installation path
install_path="/usr/lib/imio_town_time"

# WCS : Get wcs tenant
wcs_tenant=$(python $install_path/get-wcs-tenant.py 2>&1)

commune=$(echo "$wcs_tenant" | sed "s/-formulaires.guichet-citoyen.be//")

# COMBO : Get combo tenant
combo_tenant=$(echo "$wcs_tenant" | sed "s/-formulaires//")

# WCS : Create categories (Categories must be create before forms)
cp $install_path/category/town-time /var/lib/wcs/$wcs_tenant/categories/

chown -R ${USER}:${USER} /var/lib/wcs/$wcs_tenant/categories/town-time 

# WCS : Script to import xml workflow in wcs (Workflows must be create before forms)
sudo -u  wcs wcsctl -f /etc/wcs/wcs-au-quotidien.cfg runscript --vhost=$wcs_tenant $install_path/import-workflows.py $install_path

# WCS : Script to import xml forms in wcs
sudo -u  wcs wcsctl -f /etc/wcs/wcs-au-quotidien.cfg runscript --vhost=$wcs_tenant $install_path/import-forms.py $install_path
