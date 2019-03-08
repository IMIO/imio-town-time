#!/bin/sh
# $1 = domain (guichet-citoyen.be, ...)
set -e
USER="wcs"

domain=$1

# installation path
install_path="/usr/lib/imio_town_time"

# WCS : Get wcs tenant
wcs_tenant=$(python $install_path/get-wcs-tenant.py 2>&1)

commune=$(echo "$wcs_tenant" | sed "s/-formulaires.$domain//")

# COMBO : Get combo tenant
combo_tenant=$(echo "$wcs_tenant" | sed "s/-formulaires//")

# HOBO : Get hobo tenant
hobo_tenant=$(echo "$wcs_tenant" | sed "s/-formulaires/-hobo/")

# WCS : Create categories (Categories must be create before forms)
cp $install_path/category/town-time /var/lib/wcs/$wcs_tenant/categories/

if ! [ -d /var/lib/wcs/$wcs_tenant/wscalls/ ]
then
    mkdir /var/lib/wcs/$wcs_tenant/wscalls
fi
cp $install_path/wscalls/* /var/lib/wcs/$wcs_tenant/wscalls

chown -R ${USER}:${USER} /var/lib/wcs/$wcs_tenant/categories/town-time 

# WCS : Script to import xml workflow in wcs (Workflows must be create before forms)
sudo -u  wcs wcsctl -f /etc/wcs/wcs-au-quotidien.cfg runscript --vhost=$wcs_tenant $install_path/import-workflows.py $install_path

# WCS : Script to import xml forms in wcs
sudo -u  wcs wcsctl -f /etc/wcs/wcs-au-quotidien.cfg runscript --vhost=$wcs_tenant $install_path/import-forms.py $install_path

# Chrono : Deploy agenda.
sudo -u chrono chrono-manage tenant_command import_site -d $commune-agenda.$domain $install_path/agenda/agenda.json

# Hobo create var.
sudo -u hobo hobo-manage tenant_command runscript -d $hobo_tenant $install_path/hobo_create_var.py
