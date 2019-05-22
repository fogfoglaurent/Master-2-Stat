###########
#  Readme #
###########
#Nom : Thomas LAURENT
# Ce programme fonctionne de la maniere suivant
#1) Les donnees trainSing des mails sont importees ainsi que les donnees des destinataires pour chaque mail
#et les jeux de donnees sont joints
#2) Pour creer un graphe directionnel pondere par le nombre de mails entre expediteur et destinataire,
#le nombre de mail d'un expediteur vers un destinataire est calcule, puis le graphe est realise
#3) Le lien entre chaque expediteur et destinataire est mesure par le coefficient Jaccard et Adamic
#4) Pour les feature text, on procede a une tokenisation en enlevant d'avoir les chaines de caracteres 
# avec des caracteres numeriques ou speciaux, et en retirant certains mots non pertinent
#, puis on procede a une racinisation/stemming.
#5) On extrait la matrice de comptage des mots puis on estime un modele LDA avec 30 topics
#6) Pour chaque destinataire, on calcule le centroid des topics des mails recus d'un expediteur particulier
#a partir des distributions
#obtenus a partir du modele LDA
#7) Pour chaque mail, on calcule la distance au cosinus entre les topics du mail par rapport 
#au centroid expediteur-destinataire possibles
#8) Ensuite, on fait une concatenation pour obtenir un jeu de donnees avec les features text et reseau.
#9) Le jeu de donnees est equilibre pour obtenir 50% de positifs/destinataires reels et 50% de negatif
#10) On estime un modele RandomForest pour classifier une paire mail-destinataire de maniere binaire,
#egale a 1 si destinataire, 0 sinon
#11) Les donnees test sont importees et joints de la meme maniere que pour le jeu de donnees training
#12) Les feature reseaux obtenus sur le jeu d'apprentissage sont ajoutes au jeu de donnees par jointure
#13) Les feature texte sont obtenus en utilisant le modele LDA estime sur l'echantillon d'apprentissage 
#pour extraire les topics des mails test et en calculant la distance au cosinus avec chaque
#centroid expediteur-destinataire de l'echantillon d'apprentissage
#14) Enfin les scores sont obtenus en utilisant le modele RandomForest appris et pour chaque mail, les scores
#sont ranges dans l'ordre decroissant et les 10 premiers destinataires sont retournes dans un fichier csv.