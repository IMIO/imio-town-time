# imio-town-time

- E-Guichet town-time : Prise de rendez-vous pour l'aide a la completion de la declaration fiscale.  

For agenda.json : don't forget to remove specific roles in json structure before commit athis new structure.

## Comment l'installer sur une instance Téléservices (procédure manuelle)

Veiller à ce que le paquet soit installé et à jour via un bref :
`apt policy imio-town-time`
suivi d'un éventuel : ` apt update && apt install imio-town-time` si besoin est

Pour rendre effective l'installation :

1. `cd usr/lib/imio_town_time`
2. éventuellement faire un `cat install_imio-town-time.sh` afin de prendre connaissance du script bash qui va se charger d'effectuer les différentes commandes. On remarque dans les commentaires d'en-tête que le script prend un paramètre (le domaine, exemple : guichet-citoyen.be)
3. Entrer la commande `sh install_imio-town-time.sh guichet-citoyen.be` (par exemple, adapater le domaine au besoin).
Normalement, il ne doit pas y avoir d'erreur. Si il y en a, il faudra vérifier chaque étape du script, identifier où il s'est planté, corriger le problème éventuel et relancer les commandes qui n'ont pas été exécutées. Soit manuellement, soit en dupliquant le fichier et en l'adaptant pour ce faire.
