# DexBot

Hubot instance for Dexter


# Installation de NODE.JS et NPM

1.  installer node.js
2.  dans un cmd (config du proxy pour npm):
npm config set proxy http://USER:PWD@vip-pxp0-std.fr.net.intra:8080
npm config set https-proxy http://USER:PWD@vip-pxp0-std.fr.net.intra:8080
(pour les caractères spéciaux dans le mot de passe : https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references)

# Installation de Hubot

(reference : https://hubot.github.com/docs/)

1.  Dans un cmd : "npm install -g yo generator-hubot"
2.  Ajouter la variable d'environnement pour yo
   appuyer sur <Win>
   taper "env"
   cliquer sur "modifier les variables d'environnement pour votre compte"
   sélectionner la variable "Path" et cliquer sur modifier
   cliquer sur "Nouveau" et mettre la valeur (remplacer VOTRE_ID) "C:\Users\VOTRE_ID\AppData\Roaming\npm"
   OK puis OK
3.  dans un cmd aller dans un répertoire de votre choix (pour moi c:\dev\DexterBot) et taper : "yo hubot"
4.  Pour démarrer le bot, taper "bin\hubot"

# Installer les scripts personnalisés

Copier les répertoires "data" et "scripts" au même niveau que les répertoires "bin" et "node_modules" du Bot.