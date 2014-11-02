#
# Messages file for nan_upgrade.sh
#
#
if [ -f /etc/noizebox.locale ] ; then
	. /etc/noizebox.locale
fi

# Francais implicite
if [ -z "${LANG}" ] ; then
	LANG="fr_FR.ISO8859-1"
fi
	
if [ $LANG == "fr_FR.ISO8859-1" ] ; then
YES_NO="Oui                  Non"
INSTALL_FAILED="  Installation echouee  \n     ***Abandon!***     " 
INSTALL_SUCCESS="  Installation reussie  \n  Redemarrage en cours  "
INSTALL_CONFIRM="Confirmer l'installation"
INSTALL_CANCELED="  Installation annulee  \n  Redemarrage en cours  "  
INSTALL_WAIT="  Installation en cours \n   Veuillez patientez.  "
UPDATE_FAILED=" Erreur pendant la mise \n    a jour: Abandon!    " 
UPDATE_SUCCESS="  Mise a jour reussie   \n  Redemarrage en cours  "
UPDATE_CONFIRM="Confirmer la mise a jour"
UPDATE_CANCELED="  Mise a jour annulee   \n  Redemarrage en cours  "
UPDATE_WAIT="  Mise a jour en cours  \n   Veuillez patientez.  "
MOUNT_FAILED="   Erreur de montage    \n     ***Abandon!***     " 
UMOUNT_FAILED=" Erreur de demontage    \n     ***Abandon!***     " 
fi
if [ $LANG == "C" ] ; then
YES_NO="Yes                   No"
INSTALL_FAILED="  Installation errors   \n       Giving-up!       " 
INSTALL_SUCCESS="    Installation Ok.    \n       Giving-up!       "
INSTALL_CONFIRM="  Confirm installation  "
INSTALL_CANCELED="  Installation canceled \n   Restart in progress  "
INSTALL_WAIT="Installation in progress\n       Please wait.     "
UPDATE_FAILED="  Errors during update  \n       Giving-up!       "
UPDATE_SUCCESS="       Upgrade Ok.      \n   Restart in progress  "
UPDATE_CONFIRM="     Confirm upgrade?   "
UPDATE_CANCELED="     Upgrade canceled   \n   Restart in progress  "
UPDATE_WAIT="  Upgrade in progress   \n       Please wait.     "
MOUNT_FAILED="       Mount error!     \n       Giving-up!       " 
UMOUNT_FAILED="      Umount error!     \n       Giving-up!       " 
fi
