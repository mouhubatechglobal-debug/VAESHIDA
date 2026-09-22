# VAESHIDA — Architecture du code

## 1. Principe général

VAESHIDA est organisé en trois grandes zones :

- `shared` : code utilisable par le serveur et le client ;
- `server` : logique serveur protégée ;
- `client` : logique exécutée côté joueur.

Le client ne doit jamais être considéré comme fiable.

Toute logique importante concernant :

- dégâts ;
- récompenses ;
- XP ;
- monnaie ;
- inventaire ;
- progression ;
- permissions ;
- achats ;
- sauvegardes ;

doit être contrôlée côté serveur.

---

## 2. Architecture actuelle

```text
src/
└── luau/
    ├── shared/
    │   └── VAESHIDA/
    │       ├── Config/
    │       │   ├── GameConfig.luau
    │       │   └── PlayerConfig.luau
    │       │
    │       └── Types/
    │           └── PlayerData.luau
    │
    ├── server/
    │   └── VAESHIDA/
    │       ├── ServerBootstrap.server.luau
    │       └── Services/
    │           └── PlayerService.luau
    │
    └── client/
        └── VAESHIDA/
            ├── ClientBootstrap.client.luau
            └── Controllers/
                └── PlayerController.client.luau
