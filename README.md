# Smart Contract de Vote avec Fonctionnalité de Vote Quadratique

## Auteur
- Maxime Bimont
- Groupe O

## Description
Ce dépôt GitLab contient un smart contract en Solidity pour la gestion d'un processus de vote au sein d'une petite organisation. 

Le smart contract permet aux utilisateurs inscrits sur une whitelist de proposer des idées et de voter sur ces propositions. Les principales caractéristiques et fonctionnalités du contrat sont les suivantes :

- Les utilisateurs inscrits peuvent proposer des idées pendant la session d'enregistrement des propositions.
- Les votes ne sont pas confidentiels pour les utilisateurs ajoutés à la whitelist, chaque votant peut consulter les votes des autres.
- Le vainqueur est déterminé par une majorité simple, c'est-à-dire que la proposition qui reçoit le plus de votes l'emporte.
- Le processus de vote est géré par un ensemble d'états définis dans une énumération, permettant un suivi clair du déroulement du vote.
- Le contrat utilise la bibliothèque OpenZeppelin "Ownable" pour la gestion de l'administrateur du vote.
- L'ajout de la fonctionnalité de vote quadratique permet aux participants ayant une préférence marquée pour une décision de recevoir des votes supplémentaires, avec un coût quadratique pour chaque vote supplémentaire.

## Fonctionnalités Clés
Le contrat intelligent "Voting" comprend les éléments suivants :

- Structures de données pour les votants et les propositions.
- Énumération pour suivre les états du processus de vote.
- Fonctions pour l'enregistrement des votants, la proposition d'idées, le vote, le calcul du gagnant, etc.
- Événements pour notifier les changements d'état et les actions des votants.

La fonctionnalité de vote quadratique permet aux votants d'acquérir des votes supplémentaires en augmentant le coût de manière quadratique pour chaque vote supplémentaire. Cela favorise une meilleure répartition du pouvoir de vote et évite que de petits groupes puissent prendre des décisions simplement en ayant plus de votants.

